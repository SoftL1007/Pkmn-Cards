// Step Event
switch (state) {
    
    case BATTLE_STATE.START:
        repeat(3) {
            if (array_length(player_deck) > 0) {
                var c = player_deck[0];
                array_delete(player_deck, 0, 1);
                array_push(player_hand, get_card_data(c));
            } else {
                array_push(player_hand, get_card_data("potion_hyper"));
            }
        }
        turn_start_processed = false; // Initialize flag
        state = BATTLE_STATE.TURN_START_DECISION;
        break;

    case BATTLE_STATE.TURN_START_DECISION:
        mulligan_available = true; 
        
        // EXECUTE ONCE PER TURN START
        if (!turn_start_processed) {
            var p = player_team[p_active_index];
            
            // 1. Reset Card Buffs
            p.card_buffs = { atk:1.0, def:1.0, spa:1.0, spd:1.0, spe:1.0 };
            p.recalculate_stats();
            
            // 2. Status Damage (Burn/Poison) - Apply ONCE
            if (p.status_condition == "BRN" || p.status_condition == "PSN") {
                var dmg = floor(p.max_hp / 8);
                if (dmg < 1) dmg = 1;
                p.current_hp = max(0, p.current_hp - dmg);
                battle_log = p.nickname + " is hurt by its status!";
            }
            
            turn_start_processed = true; // Lock execution until next turn
        }
        
        // If player died from poison at start of turn
        if (player_team[p_active_index].is_fainted()) {
            state = BATTLE_STATE.CHECK_FAINT;
        }
        break;

    case BATTLE_STATE.DISCARD_CHOICE: break;
    case BATTLE_STATE.INPUT_PHASE: break;
    case BATTLE_STATE.SWITCH_MENU: break;
    case BATTLE_STATE.REVIVE_MENU: break; // Handled in UI

   case BATTLE_STATE.RESOLVE_PHASE:
        turn_start_processed = false; // Reset for next turn
        action_queue = [];
        var p_mon = player_team[p_active_index];
        var e_mon = enemy_team[e_active_index];
        var card_used = false;

        // 1. SWITCH
        if (selected_switch_target != -1) {
            array_push(action_queue, {
                owner: "PLAYER", actor: p_mon, type: ACTION_TYPE.SWITCH,
                data: selected_switch_target, prio: 10000, spd: 9999
            });
            selected_switch_target = -1; 
        }
        else {
            // 2. CARD
            if (selected_card != -1) {
                var card_struct = player_hand[selected_card];
                
                // REVIVE LOGIC: Revive Card actions are added via the REVIVE_MENU, 
                // so if we are here with a 'revive' card selected, it means it wasn't a revive card
                // OR we are processing the result of the menu selection.
                
                // Note: Standard cards target SELF (Active Mon).
                // Revive targets specific dead mon. logic handled in UI push.
                
                // If standard card (not revive):
                if (card_struct.id != "revive") {
                    card_anim_active = true; card_anim_timer = 60; card_anim_data = card_struct; card_used = true;
                    array_push(action_queue, {
                        owner: "PLAYER", actor: p_mon, target: p_mon, 
                        type: ACTION_TYPE.CARD, data: card_struct,
                        prio: 2000, spd: 9999
                    });
                } else {
                    // It is a revive card passed from UI
                    card_anim_active = true; card_anim_timer = 60; card_anim_data = card_struct; card_used = true;
                    // Target was stored in selected_switch_target reused or a new var?
                    // Let's assume the UI pushed the action directly to queue or we handle it here.
                    // Actually, easier: UI adds to queue for Revive. 
                    // But to keep structure, let's say UI sets 'revive_target_index'.
                    
                    var target_index = revive_target_index; // Variable set by UI
                    var target_mon = player_team[target_index];
                    
                    array_push(action_queue, {
                        owner: "PLAYER", actor: p_mon, target: target_mon,
                        type: ACTION_TYPE.CARD, data: card_struct,
                        prio: 2000, spd: 9999
                    });
                }
                array_delete(player_hand, selected_card, 1);
            }
    
            // 3. ATTACK
            if (selected_move != -1) {
                 var m_data = p_mon.moves[selected_move];
                 var p_spd_final = p_mon.stats.spe;
                 if (p_mon.status_condition == "PAR") p_spd_final = -999; 
                 
                 array_push(action_queue, {
                    owner: "PLAYER", actor: p_mon, target: e_mon,
                    type: ACTION_TYPE.ATTACK, data: m_data,
                    prio: m_data.priority, spd: p_spd_final
                });
            }
        }

        // ENEMY ACTION
        var ai_move = e_mon.moves[irandom(array_length(e_mon.moves)-1)];
        var e_spd_final = e_mon.stats.spe;
        if (e_mon.status_condition == "PAR") e_spd_final = -999;

        array_push(action_queue, {
            owner: "ENEMY", actor: e_mon, target: p_mon,
            type: ACTION_TYPE.ATTACK, data: ai_move,
            prio: ai_move.priority, spd: e_spd_final
        });

        // SORT
        var len = array_length(action_queue);
        for (var i = 0; i < len - 1; i++) {
            for (var j = 0; j < len - i - 1; j++) {
                var a = action_queue[j];
                var b = action_queue[j+1];
                var swap = false;
                if (b.prio > a.prio) swap = true;
                else if (b.prio == a.prio && b.spd > a.spd) swap = true;
                if (swap) {
                    var temp = action_queue[j];
                    action_queue[j] = action_queue[j+1];
                    action_queue[j+1] = temp;
                }
            }
        }
        
        if (card_used) state = BATTLE_STATE.ANIMATION_WAIT;
        else {
            state = BATTLE_STATE.WAIT;
            alarm[0] = 30;
        }
        break;
        
    case BATTLE_STATE.ANIMATION_WAIT:
        if (card_anim_timer > 0) card_anim_timer--;
        else {
            card_anim_active = false;
            state = BATTLE_STATE.WAIT;
            alarm[0] = 10;
        }
        break;

    case BATTLE_STATE.CHECK_FAINT:
        var p_mon = player_team[p_active_index];
        var e_mon = enemy_team[e_active_index];
        
        // Enemy Status Damage (End of Turn)
        if (e_mon.status_condition == "BRN" || e_mon.status_condition == "PSN") {
             if (e_mon.current_hp > 0) {
                 var dmg = floor(e_mon.max_hp/8);
                 if(dmg<1) dmg=1;
                 e_mon.current_hp = max(0, e_mon.current_hp - dmg);
                 battle_log = "Enemy hurt by " + e_mon.status_condition;
             }
        }

        if (p_mon.is_fainted()) {
            var alive_count = 0;
            for(var i=0; i<array_length(player_team); i++) if (player_team[i].current_hp > 0) alive_count++;
            
            if (alive_count == 0) {
                battle_log = "You have no Pokémon left! You lost!";
                state = BATTLE_STATE.WIN_LOSS;
            } else {
                battle_log = p_mon.nickname + " fainted! Choose next.";
                // Force switch
                for(var i=0; i<array_length(player_team); i++) {
                    if (player_team[i].current_hp > 0) {
                        p_active_index = i;
                        turn_start_processed = false; // New mon, new turn start logic
                        state = BATTLE_STATE.TURN_START_DECISION;
                        break;
                    }
                }
            }
        }
        else if (e_mon.is_fainted()) {
             battle_log = "Enemy " + e_mon.nickname + " fainted!";
             var found_new = false;
             for(var i=0; i<array_length(enemy_team); i++) {
                 if (enemy_team[i].current_hp > 0) {
                     e_active_index = i;
                     found_new = true;
                     break;
                 }
             }
             if (!found_new) {
                 battle_log = "Enemy has no Pokémon left! You Win!";
                 state = BATTLE_STATE.WIN_LOSS;
             } else {
                 turn_start_processed = false;
                 state = BATTLE_STATE.TURN_START_DECISION;
             }
        }
        else {
            state = BATTLE_STATE.TURN_START_DECISION;
        }
        
        selected_move = -1; selected_card = -1;
        break;
}

if (screen_shake > 0) screen_shake -= 1;
if (p_flash_alpha > 0) p_flash_alpha -= 0.1;
if (e_flash_alpha > 0) e_flash_alpha -= 0.1;
p_offset_x = lerp(p_offset_x, 0, 0.1);
e_offset_x = lerp(e_offset_x, 0, 0.1);