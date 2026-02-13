if (array_length(action_queue) > 0) {
    var act = action_queue[0];
    array_delete(action_queue, 0, 1);
    
    if (act.actor.is_fainted() && act.type != ACTION_TYPE.SWITCH) {
        battle_log = act.actor.nickname + " is fainted and cannot move!";
        alarm[0] = 60;
        exit;
    }
    
    // --- CARD EXECUTION (1 TURN BUFFS) ---
    if (act.type == ACTION_TYPE.CARD) {
        battle_log = "Player used " + act.data.name + "!";
        p_flash_alpha = 0.8; 

        if (act.data.id == "potion_hyper") {
            var old_hp = act.target.current_hp;
            act.target.current_hp = min(act.target.current_hp + 200, act.target.max_hp);
            battle_log += " Healed " + string(act.target.current_hp - old_hp) + " HP!";
        }
        else if (act.data.id == "x_atk") {
            act.target.card_buffs.atk = 1.5;
            act.target.recalculate_stats();
            battle_log += " Attack Rose (1 Turn)!";
        }
        else if (act.data.id == "x_def") {
             act.target.card_buffs.def = 1.5;
             act.target.recalculate_stats();
             battle_log += " Defense Rose (1 Turn)!";
        }
        else if (act.data.id == "x_spd") {
             act.target.card_buffs.spe = 1.5;
             act.target.recalculate_stats();
             battle_log += " Speed Rose (1 Turn)!";
        }
    }
    
    // --- ATTACK / STATUS MOVE EXECUTION ---
    else if (act.type == ACTION_TYPE.ATTACK) {
        battle_log = act.actor.nickname + " used " + act.data.name + "!";
        
        if (act.owner == "PLAYER") p_offset_x = 50; else e_offset_x = -50; 
        
        var result = calculate_move_result(act.actor, act.target, act.data);
        
        if (result.is_status) {
            // APPLY PERMANENT STAGES
            if (result.stat_change.stat != "none") {
                var s = result.stat_change.stat;
                var amt = result.stat_change.stages;
                
                // Determine target (Self or Enemy)
                // If amount is positive, apply to actor (Self Buff)
                // If amount is negative, apply to target (Enemy Debuff)
                var target_mon = (amt > 0) ? act.actor : act.target;
                
                var old_stage = variable_struct_get(target_mon.stat_stages, s);
                var new_stage = clamp(old_stage + amt, -6, 6);
                
                variable_struct_set(target_mon.stat_stages, s, new_stage);
                target_mon.recalculate_stats();
            }
            battle_log += " " + result.message;
        } 
        else {
            // DAMAGE MOVE
            if (result.hit) {
                act.target.current_hp = max(0, act.target.current_hp - result.damage);
                if (result.damage > 0) {
                    screen_shake = 10;
                    if (act.owner == "PLAYER") e_flash_alpha = 1.0; else p_flash_alpha = 1.0;
                }
                battle_log += " Dealt " + string(result.damage) + ". " + result.message;
            } else {
                battle_log += " " + result.message;
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
        // Reset Card Buffs on switch
        player_team[p_active_index].card_buffs = { atk:1.0, def:1.0, spa:1.0, spd:1.0, spe:1.0 };
        player_team[p_active_index].recalculate_stats();
        battle_log = "Switched to " + player_team[p_active_index].nickname + "!";
    }
    
    alarm[0] = 120; 
} else {
    // END OF TURN LOGIC - RESET CARD BUFFS
    var p_mon = player_team[p_active_index];
    p_mon.card_buffs = { atk:1.0, def:1.0, spa:1.0, spd:1.0, spe:1.0 };
    p_mon.recalculate_stats();
    
    state = BATTLE_STATE.CHECK_FAINT;
}