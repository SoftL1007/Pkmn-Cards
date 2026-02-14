// --------------------------------------------------------
// BATTLE MANAGER - ALARM 0 (TEXT SYNC & EXECUTION)
// --------------------------------------------------------

if (card_anim_active) {
    // If a card is still showing on screen, wait.
    alarm[0] = 10;
    exit;
}

if (array_length(action_queue) > 0) {
    var act = action_queue[0];
    array_delete(action_queue, 0, 1);
    
    // Safety check for Faint
    if (act.type != ACTION_TYPE.CARD && act.type != ACTION_TYPE.SWITCH) {
         if (act.actor.is_fainted()) {
             battle_log = act.actor.nickname + " cannot move!";
             alarm[0] = 180;
             exit;
         }
    }
    
    var user_text = (act.owner == "PLAYER") ? "Player" : "Enemy";
    
    // ----------------------
    // CARDS
    // ----------------------
    if (act.type == ACTION_TYPE.CARD) {
        // Trigger Card Animation for GUI
        card_anim_active = true;
        card_anim_phase = 1; // Start Rise
        card_anim_y = 1200;
        card_anim_data = act.data;
        
        if (act.data.type == CARD_TYPE.TRAP) {
            battle_log = user_text + " set a Trap Card!";
        } else {
            battle_log = user_text + " used " + act.data.name + "!";
            // Apply Effects
             if (act.data.type == CARD_TYPE.EVENT) {
                 if (string_pos("potion", act.data.id) != 0 || act.data.id == "full_restore") {
                    var heal_amt = 20;
                    if (act.data.id == "potion_super") heal_amt = 60;
                    if (act.data.id == "potion_hyper") heal_amt = 200;
                    if (act.data.id == "potion_max" || act.data.id == "full_restore") heal_amt = 9999;
                    act.target.current_hp = min(act.target.max_hp, act.target.current_hp + heal_amt);
                    battle_log += " Recovered HP!";
                    if (act.data.id == "full_restore" || string_pos("heal_", act.data.id) != 0) act.target.status_condition = "NONE";
                }
            }
            if (act.data.type == CARD_TYPE.MAGIC && variable_struct_exists(act.data, "effect_data")) {
                var eff = act.data.effect_data;
                if (variable_struct_exists(eff, "stat")) {
                     var amt = eff.val;
                     var curr = variable_struct_get(act.target.stat_stages, eff.stat);
                     variable_struct_set(act.target.stat_stages, eff.stat, clamp(curr + amt, -6, 6));
                     act.target.recalculate_stats();
                     battle_log += " Stats changed!";
                }
                if (variable_struct_exists(eff, "status") && act.target.status_condition == "NONE") {
                    act.target.status_condition = eff.status;
                }
            }
        }
        // Force loop to wait for card animation
        alarm[0] = 180; 
        exit;
    }

    // ----------------------
    // ATTACKS
    // ----------------------
    else if (act.type == ACTION_TYPE.ATTACK) {
        
        // Trap Check
        var t_mon = act.target; 
        if (t_mon.active_trap != undefined) {
            var tr = t_mon.active_trap;
            var tr_data = tr.effect_data;
            var match = false;
            var cat = get_gen3_category(act.data.type);
            if (tr_data.trigger == "any_atk") match = true;
            if (tr_data.trigger == "phys_atk" && cat == "PHYSICAL") match = true;
            if (tr_data.trigger == "spec_atk" && cat == "SPECIAL") match = true;
            if (tr_data.trigger == "contact" && cat == "PHYSICAL") match = true;
            
            if (match) {
                battle_log = "TRAP ACTIVATED: " + tr.name + "!";
                t_mon.active_trap = undefined; 
                if (tr_data.effect == "block") { battle_log += " Attack Blocked!"; alarm[0]=180; exit; }
                if (tr_data.effect == "reflect") { act.actor.current_hp = max(0, act.actor.current_hp-40); battle_log += " Damage Reflected!"; alarm[0]=180; exit; }
            }
        }
        
        // Attack
        var can_move = true;
        if (act.actor.status_condition == "SLP") { can_move = false; battle_log = act.actor.nickname + " is sleeping."; }
        if (act.actor.status_condition == "PAR" && irandom(100)<25) { can_move = false; battle_log = "Paralyzed!"; }
        
        if (can_move) {
            battle_log = act.actor.nickname + " used " + act.data.name + "!";
            // JUICE: Flash
            if (act.owner == "PLAYER") p_offset_x = 40; else e_offset_x = -40;
            
            var result = calculate_move_result(act.actor, act.target, act.data);
            if (result.is_status) {
                battle_log += " " + result.message;
            } else {
                if (result.hit) {
                    act.target.current_hp = max(0, act.target.current_hp - result.damage);
                    if (result.damage > 0) {
                        screen_shake = 15;
                        if (act.owner == "PLAYER") e_flash_alpha = 1.0; else p_flash_alpha = 1.0;
                    }
                    battle_log += (result.damage>0 ? "" : " It didn't affect...") + result.message;
                } else {
                    battle_log += " Missed!";
                }
            }
        }
    }
    
    // ----------------------
    // SWITCH
    // ----------------------
    else if (act.type == ACTION_TYPE.SWITCH) {
        var idx = act.data;
        if (act.owner == "PLAYER") {
            p_active_index = idx;
            player_team[idx].card_buffs = {atk:1, def:1, spa:1, spd:1, spe:1};
            player_team[idx].recalculate_stats();
            battle_log = "Player sent out " + player_team[idx].nickname + "!";
        } else {
            e_active_index = idx;
            enemy_team[idx].card_buffs = {atk:1, def:1, spa:1, spd:1, spe:1};
            enemy_team[idx].recalculate_stats();
            battle_log = "Enemy sent out " + enemy_team[idx].nickname + "!";
        }
    }
    
    // Slow down text reading time (Fix #3)
    alarm[0] = 180; 

} else {
    state = BATTLE_STATE.CHECK_FAINT;
}