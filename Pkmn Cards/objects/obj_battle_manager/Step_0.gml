switch (state) {
    
    case BATTLE_STATE.DRAW_PHASE:
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
        break;

   case BATTLE_STATE.RESOLVE_PHASE:
        action_queue = [];
        var p_mon = player_team[p_active_index];
        var e_mon = enemy_team[e_active_index];

        if (selected_switch_target != -1) {
            array_push(action_queue, {
                owner: "PLAYER", actor: p_mon, type: ACTION_TYPE.SWITCH,
                data: selected_switch_target, prio: 10000, spd: 9999
            });
            selected_switch_target = -1; 
        }
        else {
            if (selected_card != -1) {
                var card_struct = player_hand[selected_card];
                array_push(action_queue, {
                    owner: "PLAYER", actor: p_mon, target: p_mon, 
                    type: ACTION_TYPE.CARD, data: card_struct,
                    prio: 2000, spd: 9999
                });
                array_delete(player_hand, selected_card, 1);
            }
    
            if (selected_move != -1) {
                 var m_data = p_mon.moves[selected_move];
                 array_push(action_queue, {
                    owner: "PLAYER", actor: p_mon, target: e_mon,
                    type: ACTION_TYPE.ATTACK, data: m_data,
                    prio: m_data.priority, spd: p_mon.stats.spe
                });
            }
        }

        var ai_move = e_mon.moves[irandom(array_length(e_mon.moves)-1)];
        array_push(action_queue, {
            owner: "ENEMY", actor: e_mon, target: p_mon,
            type: ACTION_TYPE.ATTACK, data: ai_move,
            prio: ai_move.priority, spd: e_mon.stats.spe
        });

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
        var p_mon = player_team[p_active_index];
        var e_mon = enemy_team[e_active_index];
        
        if (p_mon.is_fainted()) {
            var alive_count = 0;
            for(var i=0; i<array_length(player_team); i++) {
                if (player_team[i].current_hp > 0) alive_count++;
            }
            
            if (alive_count == 0) {
                battle_log = "You have no Pokémon left! You lost!";
                state = BATTLE_STATE.WIN_LOSS;
            } else {
                battle_log = p_mon.nickname + " fainted! Choose next Pokémon.";
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
            state = BATTLE_STATE.DRAW_PHASE;
        }
        
        selected_move = -1;
        selected_card = -1;
        break;
}

if (screen_shake > 0) screen_shake -= 1;
if (p_flash_alpha > 0) p_flash_alpha -= 0.1;
if (e_flash_alpha > 0) e_flash_alpha -= 0.1;

p_offset_x = lerp(p_offset_x, 0, 0.1);
e_offset_x = lerp(e_offset_x, 0, 0.1);