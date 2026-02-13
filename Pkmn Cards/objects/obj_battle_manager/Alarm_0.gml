if (array_length(action_queue) > 0) {
    var act = action_queue[0];
    array_delete(action_queue, 0, 1);
    
    // Switch Faint Check: Dead mons can't attack, but can BE revived
    if (act.type != ACTION_TYPE.CARD && act.type != ACTION_TYPE.SWITCH) {
         if (act.actor.is_fainted()) {
             battle_log = act.actor.nickname + " is fainted!";
             alarm[0] = 60;
             exit;
         }
    }
    
    if (act.type == ACTION_TYPE.CARD) {
        battle_log = "Player used " + act.data.name + "!";
        p_flash_alpha = 0.8; 
        if (act.data.id == "revive") {
             // Target is passed in 'act.target'
             act.target.current_hp = floor(act.target.max_hp * 0.3);
             battle_log += " " + act.target.nickname + " revived!";
        }
        else if (act.data.id == "potion_hyper") {
            act.target.current_hp = min(act.target.current_hp + 200, act.target.max_hp);
            battle_log += " Healed!";
        }
        else if (act.data.id == "x_atk") { act.target.card_buffs.atk = 1.5; battle_log += " Atk Up!"; }
        else if (act.data.id == "x_def") { act.target.card_buffs.def = 1.5; battle_log += " Def Up!"; }
        else if (act.data.id == "x_spd") { act.target.card_buffs.spe = 1.5; battle_log += " Spe Up!"; }
        
        act.target.recalculate_stats();
    }
    else if (act.type == ACTION_TYPE.ATTACK) {
        // ... (Same attack logic as previous) ...
        // COPY PREVIOUS ATTACK LOGIC HERE (Checking Sleep/Para etc)
        // For brevity in copy-paste, I assume you have the previous attack block.
        // It hasn't changed logic-wise, just ensure it's here.
        
        // RE-PASTING ATTACK LOGIC FOR SAFETY:
        var can_move = true;
        if (act.actor.status_condition == "SLP") {
            act.actor.status_turn--;
            if (act.actor.status_turn <= 0) {
                act.actor.status_condition = "NONE";
                battle_log = act.actor.nickname + " woke up!";
            } else {
                can_move = false;
                battle_log = act.actor.nickname + " is fast asleep.";
            }
        }
        else if (act.actor.status_condition == "PAR") {
            if (irandom(100) < 25) {
                can_move = false;
                battle_log = "Paralyzed! Can't move!";
            }
        }

        if (can_move) {
            battle_log = act.actor.nickname + " used " + act.data.name + "!";
            if (act.owner == "PLAYER") p_offset_x = 50; else e_offset_x = -50; 
            
            var result = calculate_move_result(act.actor, act.target, act.data);
            
            if (result.is_status) {
                 if (result.stat_change.stat != "none") {
                     var t_mon = (result.stat_change.target == SCOPE.SELF) ? act.actor : act.target;
                     var amt = result.stat_change.stages;
                     variable_struct_set(t_mon.stat_stages, result.stat_change.stat, 
                         clamp(variable_struct_get(t_mon.stat_stages, result.stat_change.stat)+amt, -6, 6));
                     t_mon.recalculate_stats();
                 }
                 if (result.condition_change.condition != "none") {
                     var t_mon = (result.condition_change.target == SCOPE.SELF) ? act.actor : act.target;
                     if (t_mon.status_condition == "NONE") {
                         t_mon.status_condition = result.condition_change.condition;
                         if (t_mon.status_condition == "SLP") t_mon.status_turn = irandom_range(1, 3);
                         t_mon.recalculate_stats();
                     }
                 }
                 battle_log += " " + result.message;
            } 
            else {
                if (result.hit) {
                    act.target.current_hp = max(0, act.target.current_hp - result.damage);
                    if (result.damage > 0) {
                        screen_shake = 10;
                        if (act.owner == "PLAYER") e_flash_alpha = 1.0; else p_flash_alpha = 1.0;
                    }
                    battle_log += " Dealt " + string(result.damage) + ". " + result.message;
                    
                     if (result.stat_change.stat != "none") {
                         var t_mon = (result.stat_change.target == SCOPE.SELF) ? act.actor : act.target;
                         var amt = result.stat_change.stages;
                         variable_struct_set(t_mon.stat_stages, result.stat_change.stat, 
                             clamp(variable_struct_get(t_mon.stat_stages, result.stat_change.stat)+amt, -6, 6));
                         t_mon.recalculate_stats();
                     }
                     if (result.condition_change.condition != "none") {
                         var t_mon = (result.condition_change.target == SCOPE.SELF) ? act.actor : act.target;
                         if (t_mon.status_condition == "NONE") {
                             t_mon.status_condition = result.condition_change.condition;
                             if (t_mon.status_condition == "SLP") t_mon.status_turn = irandom_range(1, 3);
                             t_mon.recalculate_stats();
                         }
                     }
                } else {
                    battle_log += " " + result.message;
                }
            }
        }
        
        if (act.target.is_fainted()) {
            state = BATTLE_STATE.CHECK_FAINT;
            action_queue = [];
            exit;
        }
    }
    else if (act.type == ACTION_TYPE.SWITCH) {
        p_active_index = act.data;
        player_team[p_active_index].card_buffs = { atk:1.0, def:1.0, spa:1.0, spd:1.0, spe:1.0 };
        player_team[p_active_index].recalculate_stats();
        battle_log = "Switched to " + player_team[p_active_index].nickname + "!";
    }
    
    alarm[0] = 120; 
} else {
    state = BATTLE_STATE.CHECK_FAINT;
}