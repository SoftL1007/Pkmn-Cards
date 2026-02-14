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
        
        // --- HEALING ---
        if (act.data.type == CARD_TYPE.EVENT) {
            if (string_pos("potion", act.data.id) != 0) {
                // Parse amount logic or manual switch
                var heal_amt = 20;
                if (act.data.id == "potion_super") heal_amt = 60;
                if (act.data.id == "potion_hyper") heal_amt = 200;
                if (act.data.id == "potion_max" || act.data.id == "full_restore") heal_amt = 9999;
                
                act.target.current_hp = min(act.target.max_hp, act.target.current_hp + heal_amt);
                battle_log += " Healed!";
                
                if (act.data.id == "full_restore" || act.data.id == "heal_par" || act.data.id == "heal_brn" || act.data.id == "heal_psn") {
                    act.target.status_condition = "NONE";
                    battle_log += " Status Cured!";
                }
            }
        }
        
        // --- BUFFS / DEBUFFS (MAGIC) ---
        if (act.data.type == CARD_TYPE.MAGIC && variable_struct_exists(act.data, "effect_data")) {
            var eff = act.data.effect_data;
            
            // Stat Change
            if (variable_struct_exists(eff, "stat")) {
                var val = eff.val;
                if (eff.stat == "both_def") {
                    variable_struct_set(act.target.stat_stages, "def", clamp(act.target.stat_stages.def+val, -6, 6));
                    variable_struct_set(act.target.stat_stages, "spd", clamp(act.target.stat_stages.spd+val, -6, 6));
                    battle_log += " Defenses rose!";
                } else {
                    var curr = variable_struct_get(act.target.stat_stages, eff.stat);
                    variable_struct_set(act.target.stat_stages, eff.stat, clamp(curr + val, -6, 6));
                    battle_log += (val>0) ? " Stat rose!" : " Stat fell!";
                }
                act.target.recalculate_stats();
            }
            
            // Status
            if (variable_struct_exists(eff, "status")) {
                if (act.target.status_condition == "NONE") {
                    act.target.status_condition = eff.status;
                    battle_log += " Applied " + eff.status;
                }
            }
        }
    }
    else if (act.type == ACTION_TYPE.ATTACK) {
        
        // --- TRAP CHECK ---
        var trap_triggered = false;
        var t_mon = act.target; // The defender (who might have the trap)
        
        if (t_mon.active_trap != undefined) {
            var tr = t_mon.active_trap;
            var tr_data = tr.effect_data;
            var trigger_match = false;
            
            // Check Conditions
            var cat = get_gen3_category(act.data.type);
            var contact = (cat == "PHYSICAL"); // Simplified contact check
            
            if (tr_data.trigger == "any_atk") trigger_match = true;
            if (tr_data.trigger == "phys_atk" && cat == "PHYSICAL") trigger_match = true;
            if (tr_data.trigger == "spec_atk" && cat == "SPECIAL") trigger_match = true;
            if (tr_data.trigger == "contact" && contact) trigger_match = true;
            
            if (trigger_match) {
                battle_log = "Trap Activated! " + tr.name + "!";
                t_mon.active_trap = undefined; // Consume Trap
                trap_triggered = true;
                
                // Effect Logic
                if (tr_data.effect == "block") {
                    battle_log += " Attack blocked!";
                    alarm[0] = 60; 
                    exit; // Stop attack completely
                }
                else if (tr_data.effect == "reflect") {
                    // Calculate damage theoretically to reflect it?
                    // Simplified: Deal fixed dmg
                    act.actor.current_hp = max(0, act.actor.current_hp - 50); 
                    battle_log += " Reflected damage!";
                    alarm[0] = 60;
                    exit; // Stop incoming attack
                }
                else if (tr_data.effect == "paralyze") {
                    if (act.actor.status_condition == "NONE") act.actor.status_condition = "PAR";
                }
                else if (tr_data.effect == "damage_8") {
                    act.actor.current_hp -= floor(act.actor.max_hp/8);
                }
                // Note: Contact traps (Static/Rough Skin) usually happen AFTER damage.
                // But "Counter" happens INSTEAD of damage. 
                // Adjust flow based on strict preference. For now, Block/Reflect stops attack. Others let it pass.
                if (tr_data.effect != "paralyze" && tr_data.effect != "burn" && tr_data.effect != "poison" && tr_data.effect != "damage_8") {
                    // It was a negation trap
                    alarm[0] = 60; exit;
                }
            }
        }
        
        // ... (Proceed to standard Attack Logic) ...
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
    
					    // NEW: Apply Drain (Heal User)
					    if (variable_struct_exists(result, "heal") && result.heal > 0) {
					        act.actor.current_hp = min(act.actor.max_hp, act.actor.current_hp + result.heal);
					    }
    
					    // NEW: Apply Recoil (Hurt User)
					    if (variable_struct_exists(result, "recoil") && result.recoil > 0) {
					        act.actor.current_hp = max(0, act.actor.current_hp - result.recoil);
					        // Note: Check if user died from recoil in CHECK_FAINT state
					    }

					    if (result.damage > 0) {
					        screen_shake = 10;
					        if (act.owner == "PLAYER") e_flash_alpha = 1.0; else p_flash_alpha = 1.0;
					    }
					    // ... continue with message logs and stat changes ...
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