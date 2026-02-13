switch (state) {
    
    case BATTLE_STATE.DRAW_PHASE:
        // (Card logic remains the same as previous)
        if (array_length(player_hand) < max_hand_size && random(100) < 15) {
            array_push(player_hand, get_card_data("potion_hyper"));
            battle_log = "A Hyper Potion appeared!";
        } 
        else if (array_length(player_hand) < max_hand_size && array_length(player_deck) > 0) {
            var card_id = player_deck[0];
            array_delete(player_deck, 0, 1);
            array_push(player_hand, get_card_data(card_id));
        }
        state = BATTLE_STATE.INPUT_PHASE;
        break;

    case BATTLE_STATE.INPUT_PHASE:
        // UI handles input. We wait for "RESOLVE_PHASE"
        break;

    case BATTLE_STATE.RESOLVE_PHASE:
        // Build Action Queue
        action_queue = [];
        var p_mon = player_team[p_active_index];
        var e_mon = enemy_team[e_active_index];

        // 1. Player Action
        // Did player choose to SWITCH?
        if (selected_switch_target != -1) {
            array_push(action_queue, {
                owner: "PLAYER",
                actor: p_mon,
                type: ACTION_TYPE.SWITCH,
                data: selected_switch_target, // Index to switch to
                prio: 10000, // Switching is fastest
                spd: 9999
            });
            selected_switch_target = -1; // Reset
        }
        // Did player choose a CARD?
        else if (selected_card != -1) {
            array_push(action_queue, {
                owner: "PLAYER",
                actor: p_mon,
                target: p_mon,
                type: ACTION_TYPE.CARD,
                data: player_hand[selected_card],
                prio: 2000,
                spd: 9999
            });
            array_delete(player_hand, selected_card, 1);
        }
        // Did player choose ATTACK?
        else if (selected_move != -1) {
             var m_data = p_mon.moves[selected_move];
             array_push(action_queue, {
                owner: "PLAYER",
                actor: p_mon,
                target: e_mon,
                type: ACTION_TYPE.ATTACK,
                data: m_data,
                prio: m_data.priority,
                spd: p_mon.stats.spe
            });
        }

        // 2. Enemy Action (Basic AI)
        var ai_move = e_mon.moves[irandom(array_length(e_mon.moves)-1)];
        array_push(action_queue, {
            owner: "ENEMY",
            actor: e_mon,
            target: p_mon,
            type: ACTION_TYPE.ATTACK,
            data: ai_move,
            prio: ai_move.priority,
            spd: e_mon.stats.spe
        });

        // 3. Sort Queue (Priority > Speed)
        // Bubble sort
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
        
        state = BATTLE_STATE.WAIT;
        alarm[0] = 30;
        break;
        
    case BATTLE_STATE.CHECK_FAINT:
        // Logic to force switch if active mon is dead
        var p_mon = player_team[p_active_index];
        var e_mon = enemy_team[e_active_index];
        
        if (p_mon.is_fainted()) {
            // Check if anyone else is alive
            var alive_count = 0;
            for(var i=0; i<array_length(player_team); i++) {
                if (player_team[i].current_hp > 0) alive_count++;
            }
            
            if (alive_count == 0) {
                battle_log = "You have no Pokémon left! You lost!";
                state = BATTLE_STATE.WIN_LOSS;
            } else {
                battle_log = p_mon.nickname + " fainted! Choose next Pokémon.";
                // For prototype simplicity, auto-switch to first alive
                for(var i=0; i<array_length(player_team); i++) {
                    if (player_team[i].current_hp > 0) {
                        p_active_index = i;
                        battle_log += " Go " + player_team[i].nickname + "!";
                        state = BATTLE_STATE.DRAW_PHASE;
                        break;
                    }
                }
            }
        }
        else if (e_mon.is_fainted()) {
             battle_log = "Enemy " + e_mon.nickname + " fainted!";
             // Enemy Auto Switch
             var found_new = false;
             for(var i=0; i<array_length(enemy_team); i++) {
                 if (enemy_team[i].current_hp > 0) {
                     e_active_index = i;
                     battle_log += " Enemy sent out " + enemy_team[i].nickname + "!";
                     found_new = true;
                     break;
                 }
             }
             if (!found_new) {
                 battle_log = "Enemy has no Pokémon left! You Win!";
                 state = BATTLE_STATE.WIN_LOSS;
             } else {
                 state = BATTLE_STATE.DRAW_PHASE;
             }
        }
        else {
            // No one fainted, standard turn end
            state = BATTLE_STATE.DRAW_PHASE;
        }
        
        // Reset Inputs
        selected_move = -1;
        selected_card = -1;
        break;
}