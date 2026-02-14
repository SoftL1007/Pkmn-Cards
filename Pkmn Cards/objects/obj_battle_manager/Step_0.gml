// --------------------------------------------------------
// BATTLE MANAGER - STEP EVENT
// --------------------------------------------------------

// --- GLOBAL VISUAL LERPS ---
if (state != BATTLE_STATE.RESOLVE_PHASE && bg_dim_alpha > 0) bg_dim_alpha = lerp(bg_dim_alpha, 0, 0.1);
if (screen_shake > 0) screen_shake -= 1;
if (p_flash_alpha > 0) p_flash_alpha -= 0.1;
if (e_flash_alpha > 0) e_flash_alpha -= 0.1;
p_offset_x = lerp(p_offset_x, 0, 0.1);
e_offset_x = lerp(e_offset_x, 0, 0.1);

var p = player_team[p_active_index];
var e = enemy_team[e_active_index];
p.display_hp = lerp(p.display_hp, p.current_hp, 0.1);
e.display_hp = lerp(e.display_hp, e.current_hp, 0.1);

// Typewriter
var len_curr = string_length(battle_log_display);
var len_targ = string_length(battle_log);
if (battle_log_display != battle_log) {
    if (len_curr < len_targ) battle_log_display += string_copy(battle_log, len_curr + 1, 1); 
    else battle_log_display = "";
}

// --- CARD HOVER ANIMATION LOGIC (NEW) ---
if (state == BATTLE_STATE.INPUT_PHASE) {
    var mx = device_mouse_x_to_gui(0); 
    var my = device_mouse_y_to_gui(0);
    var hand_size = array_length(player_hand);
    var start_x = 1550 - ((hand_size - 1) * 90); 
    
    for(var c=0; c<10; c++) {
        var target = 1100; // Default off screen / Low
        
        if (c < hand_size) {
            target = 1000; // Normal position
            var cx = start_x + (c * 180);
            // Check Hover
            if (point_in_rectangle(mx, my, cx - 60, 750, cx + 60, 1080)) target = 920; 
            // Check Selection
            if (selected_card == c) target = 880; 
        }
        
        // Smooth Lerp
        hand_visual_y[c] = lerp(hand_visual_y[c], target, 0.15);
    }
} else {
    // If not input phase, cards drop down
    for(var c=0; c<10; c++) hand_visual_y[c] = lerp(hand_visual_y[c], 1300, 0.1);
}

// --- WAIT FOR CONNECTION ---
if (waiting_for_connection) {
    if (instance_exists(obj_network_manager) && array_length(obj_network_manager.opponent_team_data) > 0) {
        var op_data = obj_network_manager.opponent_team_data;
        enemy_team = [];
        for (var i = 0; i < array_length(op_data); i++) {
            var slot = op_data[i];
            if (slot != undefined) {
                var s_id = variable_struct_exists(slot, "species_id") ? slot.species_id : "charizard";
                var species = get_pokemon_species(s_id);
                var m_moves = [];
                if (variable_struct_exists(species, "move_ids")) {
                    for(var k=0; k<array_length(species.move_ids); k++) array_push(m_moves, get_move_data(species.move_ids[k]));
                }
                var new_mon = new Pokemon(species, 50, m_moves);
                new_mon.nickname = slot.nickname;
                new_mon.display_hp = new_mon.current_hp;
                array_push(enemy_team, new_mon);
            }
        }
        waiting_for_connection = false;
        state = BATTLE_STATE.START;
        battle_log = "Opponent Connected! START!";
    }
    exit;
}

// --- STATE MACHINE ---
switch (state) {
    
    case BATTLE_STATE.START:
        if (array_length(player_deck) < 3) {
            var master = obj_game_data.master_deck_list;
            array_copy(player_deck, 0, master, 0, array_length(master));
            var n = array_length(player_deck);
            for (var i = n - 1; i > 0; i--) {
                var j = irandom(i);
                var temp = player_deck[i];
                player_deck[i] = player_deck[j];
                player_deck[j] = temp;
            }
        }
        while(array_length(player_hand) < 3 && array_length(player_deck) > 0) {
             array_push(player_hand, get_card_data(player_deck[0]));
             array_delete(player_deck, 0, 1);
        }
        var heal_pool = ["potion", "potion_super", "heal_par", "heal_psn"];
        event_card_active = get_card_data(heal_pool[irandom(array_length(heal_pool)-1)]);
        turn_start_processed = false;
        state = BATTLE_STATE.TURN_START_DECISION;
        break;

    case BATTLE_STATE.TURN_START_DECISION:
        if (!turn_start_processed) {
            var pm = player_team[p_active_index];
            pm.card_buffs = { atk:1.0, def:1.0, spa:1.0, spd:1.0, spe:1.0 }; 
            pm.recalculate_stats();
            
            if (event_card_active == undefined) {
                 var heal_pool_turn = ["potion", "potion_super", "potion_hyper", "revive", "heal_brn", "heal_par"];
                 if (random(100) < 5) array_push(heal_pool_turn, "full_restore");
                 event_card_active = get_card_data(heal_pool_turn[irandom(array_length(heal_pool_turn)-1)]);
                 battle_log = "Event: " + event_card_active.name + " appeared!";
            } else {
                 battle_log = "What will you do?";
            }
            if (pm.status_condition == "BRN" || pm.status_condition == "PSN") {
                var dmg = floor(pm.max_hp / 8); if (dmg < 1) dmg = 1;
                pm.current_hp = max(0, pm.current_hp - dmg);
            }
            turn_start_processed = true;
        }
        
        if (player_team[p_active_index].is_fainted()) { state = BATTLE_STATE.CHECK_FAINT; break; }
        
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        // YES
        if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 760, 500, 910, 580)) {
             if (array_length(player_hand) >= max_hand_size) {
                state = BATTLE_STATE.DISCARD_CHOICE;
                battle_log = "Hand Full! Discard one.";
            } else {
                if (array_length(player_deck) > 0) {
                     array_push(player_hand, get_card_data(player_deck[0]));
                     array_delete(player_deck, 0, 1);
                     battle_log = "Drew a Card!";
                }
                state = BATTLE_STATE.INPUT_PHASE;
            }
            battle_log_display = "";
        }
        // NO
        if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 1010, 500, 1160, 580)) {
            state = BATTLE_STATE.INPUT_PHASE;
            battle_log = "Select Actions!";
            battle_log_display = "";
        }
        break;

    case BATTLE_STATE.DISCARD_CHOICE:
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        for (var c = 0; c < array_length(player_hand); c++) {
            var cx = 600 + (c * 150); 
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, cx, 400, cx+140, 600)) {
                array_delete(player_hand, c, 1);
                if (array_length(player_deck) > 0) {
                     array_push(player_hand, get_card_data(player_deck[0]));
                     array_delete(player_deck, 0, 1);
                }
                state = BATTLE_STATE.INPUT_PHASE;
            }
        }
        break;

    case BATTLE_STATE.INPUT_PHASE:
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        var p_mon = player_team[p_active_index];

        // 1. SWITCH
        if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 50, 780, 250, 840)) {
            state = BATTLE_STATE.SWITCH_MENU;
        }

        // 2. MULLIGAN
        if (mulligan_available) {
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 860, 20, 1060, 100)) {
                player_hand = [];
                repeat(3) { 
                    if(array_length(player_deck)>0) { 
                        array_push(player_hand, get_card_data(player_deck[0])); 
                        array_delete(player_deck,0,1); 
                    } 
                }
                mulligan_available = false;
                battle_log = "Hand Reshuffled!";
            }
        }

        // 3. MOVE
        for (var i = 0; i < array_length(p_mon.moves); i++) {
            var row = floor(i / 2); var col = i % 2;
            var btn_x = 50 + (col * 320); var btn_y = 870 + (row * 100);
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, btn_x, btn_y, btn_x+300, btn_y+90)) {
                selected_move = (selected_move == i) ? -1 : i;
            }
        }

        // 4. HAND SELECTION
        var hand_size = array_length(player_hand);
        var start_x = 1550 - ((hand_size - 1) * 90);
        for (var c = 0; c < hand_size; c++) {
            var cx = start_x + (c * 180);
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, cx - 60, 750, cx + 60, 1080)) {
                var card = player_hand[c];
                if (card.id == "revive" || card.id == "revive_max") {
                    selected_card = c;
                    state = BATTLE_STATE.REVIVE_MENU;
                } else {
                    selected_card = (selected_card == c) ? -1 : c;
                }
            }
        }
        
        // 5. EVENT CARD
        if (event_card_active != undefined) {
             var ex = 970; var ey = 260;
             if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, ex-60, ey-80, ex+60, ey+80)) {
                 selected_card = (selected_card == 100) ? -1 : 100;
             }
        }

        // 6. GO BUTTON
        if ((selected_move != -1 || selected_card != -1) && mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 860, 780, 1060, 840)) {
            var _cid_str = "none";
            if (selected_card != -1) {
                if (selected_card == 100) {
                    if (event_card_active != undefined) _cid_str = event_card_active.id;
                } else if (selected_card < array_length(player_hand)) {
                    _cid_str = player_hand[selected_card].id;
                }
            }

            var my_act = {
                move_index: selected_move,
                card_index: selected_card,
                card_id_str: _cid_str,
                switch_index: -1 
            };

            if (obj_game_data.game_mode == "LOCAL") {
                state = BATTLE_STATE.RESOLVE_PHASE;
            }
            else if (obj_game_data.game_mode == "ONLINE") {
                if (instance_exists(obj_network_manager)) {
                    obj_network_manager.send_packet(NETWORK_MSG.SUBMIT_ACTION, my_act);
                }
                online_my_action = my_act;
                online_player_ready = true;
                if (online_enemy_ready) {
                    state = BATTLE_STATE.RESOLVE_PHASE;
                } else {
                    battle_log = "Waiting for Opponent...";
                    state = BATTLE_STATE.WAIT; 
                }
            }
        }
        break;

    case BATTLE_STATE.SWITCH_MENU:
    case BATTLE_STATE.REVIVE_MENU:
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 700, 900, 900, 1000)) {
            state = BATTLE_STATE.INPUT_PHASE;
            selected_switch_target = -1;
            revive_target_index = -1;
        }
        
        for (var i = 0; i < array_length(player_team); i++) {
            var pm = player_team[i];
            var py = 200 + (i * 120);
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 100, py, 600, py+100)) {
                if (state == BATTLE_STATE.SWITCH_MENU) {
                    if (pm.current_hp > 0 && i != p_active_index) {
                        selected_switch_target = i;
                        if (obj_game_data.game_mode == "ONLINE") {
                            var sw_act = { move_index:-1, card_index:-1, card_id_str:"none", switch_index: i };
                            obj_network_manager.send_packet(NETWORK_MSG.SUBMIT_ACTION, sw_act);
                            online_my_action = sw_act;
                            online_player_ready = true;
                            state = (online_enemy_ready) ? BATTLE_STATE.RESOLVE_PHASE : BATTLE_STATE.WAIT;
                        } else {
                            state = BATTLE_STATE.RESOLVE_PHASE; 
                        }
                    }
                }
            }
        }
        break;

    case BATTLE_STATE.RESOLVE_PHASE:
        if (bg_dim_alpha < 0.6) bg_dim_alpha += 0.05;
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
                var card_struct = undefined;
                if (selected_card == 100) {
                     card_struct = event_card_active;
                     event_card_active = undefined;
                } else {
                     card_struct = player_hand[selected_card];
                     array_delete(player_hand, selected_card, 1); 
                }
                
                if (card_struct.type == CARD_TYPE.TRAP) {
                     p_mon.active_trap = card_struct;
                     array_push(action_queue, {
                        owner: "PLAYER", actor: p_mon, target: p_mon,
                        type: ACTION_TYPE.CARD, data: card_struct,
                        prio: 9999, spd: 9999
                    });
                } else {
                    var target = (card_struct.target_scope == SCOPE.SELF) ? p_mon : e_mon;
                    array_push(action_queue, {
                        owner: "PLAYER", actor: p_mon, target: target, 
                        type: ACTION_TYPE.CARD, data: card_struct,
                        prio: 3000, spd: 9999 
                    });
                }
            }
            if (selected_move != -1) {
                 var m_data = p_mon.moves[selected_move];
                 var p_spd = (p_mon.status_condition == "PAR") ? 0 : p_mon.stats.spe;
                 array_push(action_queue, {
                    owner: "PLAYER", actor: p_mon, target: e_mon,
                    type: ACTION_TYPE.ATTACK, data: m_data,
                    prio: m_data.priority, spd: p_spd
                });
            }
        }

        var e_spd = (e_mon.status_condition == "PAR") ? 0 : e_mon.stats.spe;
        
        if (obj_game_data.game_mode == "ONLINE") {
            if (online_enemy_action.switch_index != -1) {
                 array_push(action_queue, {
                    owner: "ENEMY", actor: e_mon, type: ACTION_TYPE.SWITCH,
                    data: online_enemy_action.switch_index, prio: 10000, spd: 9999
                });
            } else {
                if (variable_struct_exists(online_enemy_action, "card_id_str") && online_enemy_action.card_id_str != "none") {
                    var c_data = get_card_data(online_enemy_action.card_id_str);
                    if (c_data.type == CARD_TYPE.TRAP) {
                        e_mon.active_trap = c_data; 
                         array_push(action_queue, {
                            owner: "ENEMY", actor: e_mon, target: e_mon,
                            type: ACTION_TYPE.CARD, data: c_data,
                            prio: 9999, spd: 9999
                        });
                    } else {
                        var t_scope = (c_data.target_scope == SCOPE.SELF) ? e_mon : p_mon;
                        array_push(action_queue, {
                            owner: "ENEMY", actor: e_mon, target: t_scope,
                            type: ACTION_TYPE.CARD, data: c_data,
                            prio: 3000, spd: 9999
                        });
                    }
                }
                if (online_enemy_action.move_index != -1) {
                    var e_move = e_mon.moves[online_enemy_action.move_index];
                    array_push(action_queue, {
                        owner: "ENEMY", actor: e_mon, target: p_mon,
                        type: ACTION_TYPE.ATTACK, data: e_move,
                        prio: e_move.priority, spd: e_spd
                    });
                }
            }
        } else {
            var r_move = e_mon.moves[irandom(array_length(e_mon.moves)-1)];
            array_push(action_queue, {
                owner: "ENEMY", actor: e_mon, target: p_mon,
                type: ACTION_TYPE.ATTACK, data: r_move,
                prio: r_move.priority, spd: e_spd
            });
        }

        var len = array_length(action_queue);
        for (var i = 0; i < len - 1; i++) {
            for (var j = 0; j < len - i - 1; j++) {
                var a = action_queue[j]; var b = action_queue[j+1];
                var swap = false;
                if (b.prio > a.prio) swap = true;
                else if (b.prio == a.prio && b.spd > a.spd) swap = true;
                if (swap) {
                    var t = action_queue[j];
                    action_queue[j] = action_queue[j+1];
                    action_queue[j+1] = t;
                }
            }
        }
        selected_move = -1; selected_card = -1; selected_switch_target = -1;
        online_player_ready = false; online_enemy_ready = false;
        
        state = BATTLE_STATE.ANIMATION_WAIT; 
        alarm[0] = 30; 
        break;

    case BATTLE_STATE.ANIMATION_WAIT:
        if (card_anim_active) {
            if (card_anim_phase == 1) { 
                 card_anim_y = lerp(card_anim_y, 540, 0.2); 
                 if (abs(card_anim_y - 540) < 5) { card_anim_y = 540; card_anim_phase = 2; alarm[1] = 60; }
            }
            if (card_anim_phase == 3) card_anim_active = false;
        }
        break;
        
    case BATTLE_STATE.CHECK_FAINT:
        if (bg_dim_alpha > 0) bg_dim_alpha -= 0.05;
        var pm = player_team[p_active_index];
        var em = enemy_team[e_active_index];
        if (pm.is_fainted()) {
            battle_log = "Your Pokémon fainted!";
             var found = false; for(var i=0; i<array_length(player_team); i++) if (player_team[i].current_hp > 0) { p_active_index = i; found=true; break; }
            if(!found) { battle_log="DEFEAT"; state = BATTLE_STATE.WIN_LOSS; } 
            else state = BATTLE_STATE.TURN_START_DECISION;
        } 
        else if (em.is_fainted()) {
            battle_log = "Enemy fainted!";
             var found = false; for(var i=0; i<array_length(enemy_team); i++) if (enemy_team[i].current_hp > 0) { e_active_index = i; found=true; break; }
            if(!found) { battle_log="VICTORY"; state = BATTLE_STATE.WIN_LOSS; } 
            else state = BATTLE_STATE.TURN_START_DECISION;
        } else {
            state = BATTLE_STATE.TURN_START_DECISION;
        }
        break;
}