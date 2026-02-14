// -----------------------------------------------------------
// 1. SAFETY & INITIALIZATION
// -----------------------------------------------------------
if (obj_game_data.game_mode == "ONLINE") {
    // Stop everything if we are online but have no opponent data yet
    if (array_length(enemy_team) == 0 && !waiting_for_connection) {
        waiting_for_connection = true;
    }
}

// 2. CONNECTION HANDLER (Injects Enemy Team)
if (waiting_for_connection) {
     if (instance_exists(obj_network_manager) && obj_network_manager.opponent_team_received) {
        var op_data = obj_network_manager.opponent_team_data;
        enemy_team = [];
        
        // PARSE THE TEAM
        for (var i = 0; i < array_length(op_data); i++) {
            var slot = op_data[i];
            if (slot != undefined) {
                // Determine ID (Fallback to Charizard if error)
                var s_id = variable_struct_exists(slot, "species_id") ? slot.species_id : "charizard";
                var species = get_pokemon_species(s_id);
                
                // Get Moves
                var m_moves = [];
                if (variable_struct_exists(species, "move_ids")) { 
                    for(var k=0; k<array_length(species.move_ids); k++) 
                        array_push(m_moves, get_move_data(species.move_ids[k])); 
                }
                
                // Build Pokemon Struct
                var new_mon = new Pokemon(species, 50, m_moves);
                new_mon.nickname = slot.nickname; 
                new_mon.display_hp = new_mon.current_hp;
                
                array_push(enemy_team, new_mon);
            }
        }
        
        // Start Battle
        waiting_for_connection = false; 
        state = BATTLE_STATE.START; 
        battle_log = "Opponent Connected! START!";
    }
    // STOP HERE until connected
    exit; 
}

// -----------------------------------------------------------
// 3. VISUALS & ANIMATIONS
// -----------------------------------------------------------
if (reshuffle_anim_active) {
    reshuffle_timer++;
    if (reshuffle_timer > 60) { reshuffle_anim_active = false; reshuffle_timer = 0; }
}

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

// TYPEWRITER EFFECT
var len_curr = string_length(battle_log_display); 
var len_targ = string_length(battle_log);
text_timer++;
if (battle_log_display != battle_log) {
    if (text_timer >= text_char_delay) { 
        if (len_curr < len_targ) battle_log_display += string_copy(battle_log, len_curr + 1, 1);
        else battle_log_display = battle_log;
        text_timer = 0;
    }
} else {
    text_timer = 0;
}

var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
var hand_size = array_length(player_hand);

// HAND LERPING LOGIC
if (state == BATTLE_STATE.INPUT_PHASE) {
    var start_x = 1550 - ((hand_size - 1) * 90); 
    for(var c=0; c<10; c++) {
        var target = 1100; 
        if (c < hand_size) {
            target = 1000;
            var cx = start_x + (c * 180);
            if (point_in_rectangle(mx, my, cx - 60, 750, cx + 60, 1080)) target = 920; 
            if (selected_card == c) target = 880; 
        }
        hand_visual_y[c] = lerp(hand_visual_y[c], target, 0.15);
    }
} 
else if (state == BATTLE_STATE.DISCARD_CHOICE) {
    var d_start_x = 960 - ((hand_size - 1) * 110); 
    for(var c=0; c<10; c++) {
        var target = 1200; 
        if (c < hand_size) {
            var cx = d_start_x + (c * 220); 
            target = 880; 
            if (point_in_rectangle(mx, my, cx-75, 750, cx+75, 1080)) target = 850; 
            if (discard_selected_index == c) target = 750;
        }
        hand_visual_y[c] = lerp(hand_visual_y[c], target, 0.15);
    }
}
else {
    for(var c=0; c<10; c++) hand_visual_y[c] = lerp(hand_visual_y[c], 1300, 0.1);
}

// -----------------------------------------------------------
// 4. MAIN STATE MACHINE
// -----------------------------------------------------------
switch (state) {
    
    // --- BATTLE START ---
    case BATTLE_STATE.START:
        // Initialize Deck if needed
        if (array_length(player_deck) < 3) { 
            var m = obj_game_data.master_deck_list; 
            array_copy(player_deck,0,m,0,array_length(m)); 
            deck_shuffle(); // Assume shuffle script exists, or use loop below
        }
        // Initial Hand Draw
        while(array_length(player_hand)<3 && array_length(player_deck)>0) { 
            array_push(player_hand, get_card_data(player_deck[0])); 
            array_delete(player_deck,0,1); 
        }
        // First Event
        var hp=["potion","potion","potion_super","heal_par","heal_psn"]; 
        event_card_active = get_card_data(hp[irandom(array_length(hp)-1)]);
        turn_start_processed=false; state=BATTLE_STATE.TURN_START_DECISION;
        break;

    // --- TURN START ---
    case BATTLE_STATE.TURN_START_DECISION:
        // Logic Processing (Damage/Events)
        if (!turn_start_processed) {
            var pm = player_team[p_active_index]; 
            pm.card_buffs = { atk:1.0, def:1.0, spa:1.0, spd:1.0, spe:1.0 }; 
            pm.recalculate_stats();
            
            var msg = "";
            // Status Damage
            if (pm.status_condition == "BRN" || pm.status_condition == "PSN") { 
                var dmg=floor(pm.max_hp/8); if(dmg<1)dmg=1; 
                pm.current_hp=max(0,pm.current_hp-dmg); 
                msg = pm.nickname + " takes " + pm.status_condition + " damage!";
            }
            // Event Gen
            if (event_card_active == undefined) {
                 var hpt = ["potion", "potion", "potion_super", "heal_par", "heal_brn", "heal_psn", "potion_hyper", "revive"]; 
                 if (random(100) < 10) array_push(hpt, "full_restore", "potion_max", "revive_max");
                 
                 event_card_active = get_card_data(hpt[irandom(array_length(hpt)-1)]); 
                 if (msg != "") msg += " And ";
                 msg += "New Event! " + event_card_active.name + "!";
            }
            // Transition Logic
            if (msg != "") {
                battle_log = msg;
                state = BATTLE_STATE.WAIT; 
                alarm[0] = 180; // Go to wait for reading
            } else {
                battle_log = "What will " + pm.nickname + " do?"; 
                battle_log_display = "";
            }
            turn_start_processed = true;
        }
        
        // Instant Faint Check
        if (player_team[p_active_index].is_fainted()) { state = BATTLE_STATE.CHECK_FAINT; break; }
        
        // Input Handling for Draw Choice
        if (state == BATTLE_STATE.TURN_START_DECISION) {
            if (string_pos("Event!", battle_log) != 0 || string_pos("damage!", battle_log) != 0) {
                 if (battle_log_display == battle_log) { 
                     battle_log = "Draw a card?"; battle_log_display = "";
                 }
            }
            // YES BUTTON
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 760, 500, 910, 580)) {
                 if (array_length(player_hand) >= max_hand_size) { 
                     state = BATTLE_STATE.DISCARD_CHOICE; 
                     battle_log = "Hand Full! Discard one."; 
                 } else { 
                     if (array_length(player_deck)>0) { 
                         array_push(player_hand, get_card_data(player_deck[0])); 
                         array_delete(player_deck, 0, 1); 
                         battle_log = "Drew a Card!"; 
                     } 
                     state = BATTLE_STATE.INPUT_PHASE; 
                     battle_log = "What will " + player_team[p_active_index].nickname + " do?";
                 }
                 battle_log_display = "";
            }
            // NO BUTTON
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 1010, 500, 1160, 580)) { 
                state = BATTLE_STATE.INPUT_PHASE; 
                battle_log = "What will " + player_team[p_active_index].nickname + " do?";
                battle_log_display = ""; 
            }
        }
        break;

    // --- DISCARD CHOICE ---
    case BATTLE_STATE.DISCARD_CHOICE:
        var d_start_x = 960 - ((hand_size - 1) * 110);
        // Select Card
        for (var c = 0; c < hand_size; c++) {
            var cx = d_start_x + (c * 220); 
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, cx-75, 750, cx+75, 1080)) discard_selected_index = c;
        }
        // Confirm Buttons
        if (discard_selected_index != -1) {
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 800, 480, 950, 560)) {
                array_delete(player_hand, discard_selected_index, 1);
                // Draw new card now that space is made
                if (array_length(player_deck) > 0) { array_push(player_hand, get_card_data(player_deck[0])); array_delete(player_deck, 0, 1); }
                discard_selected_index = -1; state = BATTLE_STATE.INPUT_PHASE; battle_log = "Card Discarded!";
            }
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 970, 480, 1120, 560)) discard_selected_index = -1;
        }
        break;

    // --- INPUT PHASE (MOVES & CARDS) ---
    case BATTLE_STATE.INPUT_PHASE:
        // Switch Button
        if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 50, 780, 250, 840)) state = BATTLE_STATE.SWITCH_MENU;
        
        // Reshuffle / Mulligan
        if (mulligan_available) {
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 860, 20, 1060, 100)) {
                player_hand = []; 
                repeat(3) { if(array_length(player_deck)>0){ array_push(player_hand, get_card_data(player_deck[0])); array_delete(player_deck,0,1); } }
                mulligan_available = false; battle_log = "Hand Reshuffled!";
            }
        }
        
        // Select Move
        var p_mon = player_team[p_active_index];
        for (var i = 0; i < array_length(p_mon.moves); i++) {
            var row = floor(i / 2); var col = i % 2; var btn_x = 50 + (col * 320); var btn_y = 870 + (row * 100);
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, btn_x, btn_y, btn_x+300, btn_y+90)) selected_move = (selected_move == i) ? -1 : i;
        }
        
        // Select Card
        var start_x = 1550 - ((hand_size - 1) * 90);
        for (var c = 0; c < hand_size; c++) {
            var cx = start_x + (c * 180);
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, cx - 60, 750, cx + 60, 1080)) {
                var card = player_hand[c];
                // Check if card needs target menu (Revive)
                if (card.id == "revive" || card.id == "revive_max") { selected_card = c; state = BATTLE_STATE.REVIVE_MENU; } 
                else selected_card = (selected_card == c) ? -1 : c;
            }
        }
        
        // Event Card Select
        if (event_card_active != undefined) {
             var ex = 970; var ey = 260;
             if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, ex-60, ey-80, ex+60, ey+80)) selected_card = (selected_card == 100) ? -1 : 100;
        }
        
        // GO Button (Confirm)
        if ((selected_move != -1 || selected_card != -1) && mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 860, 780, 1060, 840)) {
            // Build Action Struct
            var my_act = { 
                move_index: selected_move, 
                card_index: selected_card, 
                // Determine ID strictly for Networking
                card_id_str: (selected_card==100 && event_card_active!=undefined) ? event_card_active.id : ((selected_card!=-1 && selected_card<array_length(player_hand)) ? player_hand[selected_card].id : "none"), 
                switch_index: -1 
            };
            
            if (obj_game_data.game_mode == "LOCAL") {
                state = BATTLE_STATE.RESOLVE_PHASE;
            } 
            else if (obj_game_data.game_mode == "ONLINE") {
                 // Send Logic
                 if (instance_exists(obj_network_manager)) obj_network_manager.send_packet(NETWORK_MSG.SUBMIT_ACTION, my_act);
                 online_my_action = my_act; 
                 online_player_ready = true;
                 // If enemy is already ready, go. If not, wait.
                 if (online_enemy_ready) state = BATTLE_STATE.RESOLVE_PHASE; 
                 else { battle_log = "Waiting for Opponent..."; state = BATTLE_STATE.WAIT; }
            }
        }
        break;

    // --- MENUS (SWITCH/REVIVE) ---
    case BATTLE_STATE.SWITCH_MENU:
    case BATTLE_STATE.REVIVE_MENU:
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        // Cancel Button
        if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 700, 900, 900, 1000)) {
            state = BATTLE_STATE.INPUT_PHASE; 
            selected_switch_target = -1; revive_target_index = -1;
            battle_log = "What will " + player_team[p_active_index].nickname + " do?"; 
            battle_log_display = "";
        }
        // Pokemon Selection
        for (var i = 0; i < array_length(player_team); i++) {
            var pm = player_team[i]; var py = 200 + (i * 120);
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx, my, 100, py, 600, py+100)) {
                
                // Normal Switching
                if (state == BATTLE_STATE.SWITCH_MENU) {
                    if (pm.current_hp > 0 && i != p_active_index) {
                        selected_switch_target = i;
                        if (obj_game_data.game_mode == "ONLINE") {
                            var sw_act = { move_index:-1, card_index:-1, card_id_str:"none", switch_index: i };
                            obj_network_manager.send_packet(NETWORK_MSG.SUBMIT_ACTION, sw_act);
                            online_my_action = sw_act; 
                            online_player_ready = true;
                            state = (online_enemy_ready) ? BATTLE_STATE.RESOLVE_PHASE : BATTLE_STATE.WAIT;
                        } else state = BATTLE_STATE.RESOLVE_PHASE; 
                    }
                }
            }
        }
        break;
        
    // --- ONLINE WAIT ---
    case BATTLE_STATE.WAIT:
        // Simply sit here until obj_network_manager updates the flags
        if (online_player_ready && online_enemy_ready) {
            state = BATTLE_STATE.RESOLVE_PHASE;
        }
        break;

    // --- RESOLVE (TURN EXECUTION) ---
    case BATTLE_STATE.RESOLVE_PHASE:
        if (bg_dim_alpha < 0.6) bg_dim_alpha += 0.05;
        action_queue = [];
        var p_mon = player_team[p_active_index]; 
        var e_mon = enemy_team[e_active_index];
        
        // 1. Queue Player Action
        if (selected_switch_target != -1) { 
            array_push(action_queue, { owner: "PLAYER", actor: p_mon, type: ACTION_TYPE.SWITCH, data: selected_switch_target, prio: 10000, spd: 9999 }); 
            selected_switch_target=-1; 
        } 
        else {
             if (selected_card != -1) { 
                 var cd = (selected_card==100) ? event_card_active : player_hand[selected_card]; 
                 if (selected_card==100) event_card_active=undefined; 
                 else array_delete(player_hand, selected_card, 1);
                 
                 var tg = (cd.target_scope==SCOPE.SELF) ? p_mon : e_mon;
                 array_push(action_queue, { owner: "PLAYER", actor: p_mon, target: tg, type: ACTION_TYPE.CARD, data: cd, prio: (cd.type==CARD_TYPE.TRAP)?9999:3000, spd: 9999 });
                 if(cd.type==CARD_TYPE.TRAP) p_mon.active_trap=cd; 
             }
             if (selected_move != -1) { 
                 var md = p_mon.moves[selected_move]; 
                 array_push(action_queue, { owner:"PLAYER", actor:p_mon, target:e_mon, type:ACTION_TYPE.ATTACK, data:md, prio:md.priority, spd:(p_mon.status_condition=="PAR")?0:p_mon.stats.spe }); 
             }
        }
        
        // 2. Queue Enemy Action
        if (obj_game_data.game_mode == "LOCAL") {
            // Local AI
            var r_move = e_mon.moves[irandom(array_length(e_mon.moves)-1)];
            array_push(action_queue, { owner:"ENEMY", actor:e_mon, target:p_mon, type:ACTION_TYPE.ATTACK, data:r_move, prio:r_move.priority, spd:e_mon.stats.spe });
        } else {
             // Online Data Processing
             if (online_enemy_action.switch_index != -1) { 
                 array_push(action_queue, { owner: "ENEMY", actor: e_mon, type: ACTION_TYPE.SWITCH, data: online_enemy_action.switch_index, prio: 10000, spd: 9999 }); 
             }
             else { 
                 // Parse Card from ID String
                 if (online_enemy_action.card_id_str != "none") { 
                     var cd = get_card_data(online_enemy_action.card_id_str); 
                     var scope_targ = (cd.target_scope==SCOPE.SELF) ? e_mon : p_mon; // Correct Target Scope for enemy usage
                     array_push(action_queue, { owner:"ENEMY", actor:e_mon, target:scope_targ, type:ACTION_TYPE.CARD, data:cd, prio:3000, spd:9999 }); 
                 }
                 // Parse Move from Index
                 if (online_enemy_action.move_index != -1) { 
                     var em = e_mon.moves[online_enemy_action.move_index]; 
                     array_push(action_queue, { owner:"ENEMY", actor:e_mon, target:p_mon, type:ACTION_TYPE.ATTACK, data:em, prio:em.priority, spd:e_mon.stats.spe }); 
                 }
             }
        }
        
        // 3. Sort Actions (Speed Logic)
        var len = array_length(action_queue); 
        for(var i=0;i<len-1;i++){ 
            for(var j=0;j<len-i-1;j++){ 
                var a=action_queue[j]; var b=action_queue[j+1]; 
                // Swap if B is faster
                if(b.prio>a.prio || (b.prio==a.prio && b.spd>a.spd)) { 
                    var t=action_queue[j]; action_queue[j]=action_queue[j+1]; action_queue[j+1]=t; 
                } 
            } 
        }
        
        // Reset Inputs
        selected_move = -1; selected_card = -1; online_player_ready=false; online_enemy_ready=false;
        
        state = BATTLE_STATE.ANIMATION_WAIT; 
        alarm[0] = 30; // Start Turn processing loop
        break;

    // --- ANIMATION / WAIT HANDLING ---
    case BATTLE_STATE.ANIMATION_WAIT:
        if (card_anim_active) {
            // Lerp Visuals for Card
            if (card_anim_phase == 1) { 
                card_anim_y = lerp(card_anim_y, 540, 0.2); 
                if (abs(card_anim_y - 540) < 5) { card_anim_y = 540; card_anim_phase = 2; alarm[1] = 60; } 
            }
            if (card_anim_phase == 3) card_anim_active = false;
        }
        break;

    // --- POKEMON SWITCHING ANIMATION ---
    case BATTLE_STATE.ANIMATION_SWITCH: 
        // Wait for text to finish reading
        if (string_length(battle_log_display) < string_length(battle_log)) exit; 
        switch_delay_timer++;
        if (switch_delay_timer < 60) exit; 
        
        if (switch_phase == 1) { 
            // Scale DOWN (Retreat)
            if (switch_processing_actor == "PLAYER") {
                p_scale = lerp(p_scale, 0, 0.1); 
                if (p_scale < 0.1) {
                    p_active_index = switch_target_index;
                    // Reset Stats on Switch
                    var new_pm = player_team[p_active_index]; new_pm.card_buffs = {atk:1, def:1, spa:1, spd:1, spe:1}; new_pm.recalculate_stats();
                    switch_phase = 2; switch_delay_timer = 0;
                    battle_log = "Go! " + new_pm.nickname + "!"; battle_log_display = "";
                    part_particles_create(global.part_sys, 400, 1100, global.pt_poof, 30); 
                }
            } else {
                e_scale = lerp(e_scale, 0, 0.1); 
                if (e_scale < 0.1) {
                    e_active_index = switch_target_index;
                    var new_em = enemy_team[e_active_index]; new_em.card_buffs = {atk:1, def:1, spa:1, spd:1, spe:1}; new_em.recalculate_stats();
                    switch_phase = 2; switch_delay_timer = 0;
                    battle_log = "Foe sent " + new_em.nickname + "!"; battle_log_display = "";
                    part_particles_create(global.part_sys, 1580, 950, global.pt_poof, 30);
                }
            }
        } 
        else if (switch_phase == 2) { 
            // Scale UP (Deploy)
            if (switch_processing_actor == "PLAYER") {
                p_scale = lerp(p_scale, 1.0, 0.1);
                if (p_scale > 0.95) { p_scale = 1.0; state = BATTLE_STATE.ANIMATION_WAIT; alarm[0] = 60; } 
            } else {
                e_scale = lerp(e_scale, 1.0, 0.1);
                if (e_scale > 0.95) { e_scale = 1.0; state = BATTLE_STATE.ANIMATION_WAIT; alarm[0] = 60; }
            }
        }
        break;
        
    // --- CHECK FAINT / WIN CONDITION ---
    case BATTLE_STATE.CHECK_FAINT:
        if (bg_dim_alpha > 0) bg_dim_alpha -= 0.05;
        var pm = player_team[p_active_index]; 
        var em = enemy_team[e_active_index];
        
        // PLAYER FAINT
        if (pm.is_fainted()) {
            battle_log = pm.nickname + " fainted!";
            var found = -1; 
            for(var i=0; i<array_length(player_team); i++) { if (player_team[i].current_hp > 0) { found = i; break; } }
            if(found == -1) { battle_log="DEFEAT"; state = BATTLE_STATE.WIN_LOSS; } 
            else {
                // Auto Switch
                switch_target_index = found;
                switch_processing_actor = "PLAYER";
                switch_phase = 1; 
                state = BATTLE_STATE.ANIMATION_SWITCH;
                turn_start_processed = false; 
            }
        } 
        // ENEMY FAINT
        else if (em.is_fainted()) {
            battle_log = em.nickname + " fainted!";
            var found = -1; 
            for(var i=0; i<array_length(enemy_team); i++) { if (enemy_team[i].current_hp > 0) { found = i; break; } }
            if(found == -1) { battle_log="VICTORY"; state = BATTLE_STATE.WIN_LOSS; } 
            else {
                switch_target_index = found;
                switch_processing_actor = "ENEMY";
                switch_phase = 1; 
                state = BATTLE_STATE.ANIMATION_SWITCH;
                turn_start_processed = false; 
            }
        } 
        else {
            // No faints, new turn
            turn_start_processed = false; 
            state = BATTLE_STATE.TURN_START_DECISION;
        }
        break;
        
    case BATTLE_STATE.WIN_LOSS: 
        // End Game logic (Menus etc) would go here
        break;
}