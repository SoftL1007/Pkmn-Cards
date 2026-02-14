draw_set_font(menu_font);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var click = mouse_check_button_pressed(mb_left);

switch(state) {
    
    // ============================================================
    // MAIN MENU
    // ============================================================
    case MENU_STATE.MAIN:
        target_anim_y = 0;
        draw_set_color(c_dkgray); draw_rectangle(0,0,1920,1080,false);
        
        var dy = menu_anim_y; // Apply animation offset if desired
        
        draw_set_halign(fa_center); draw_set_color(c_white);
        draw_text_transformed(960, 200 + dy, "POKÉMON CARDS BATTLE", 2, 2, 0);
        
        if (draw_button_juicy(860, 500+dy, 200, 80, "PLAY", mx, my, click)) {
            state = MENU_STATE.MODE_SELECT;
        }
        if (draw_button_juicy(860, 650+dy, 200, 80, "TEAM BUILDER", mx, my, click)) {
            state = MENU_STATE.TEAM_BUILDER;
            selected_slot = -1;
            scroll_offset = 0;
        }
        if (draw_button_juicy(860, 800+dy, 200, 80, "QUIT", mx, my, click)) {
            game_end();
        }
        break;

    // ============================================================
    // TEAM BUILDER
    // ============================================================
    case MENU_STATE.TEAM_BUILDER:
        draw_set_color(c_black); draw_rectangle(0,0,1920,1080,false);
        
        // --- LEFT: PLAYER TEAM ---
        draw_set_color(c_white); draw_text(50, 50, "YOUR TEAM");
        
        for(var i=0; i<6; i++) {
            var box_x = 100;
            var box_y = 150 + (i * 140);
            
            // Selection Pulse
            var is_sel = (selected_slot == i);
            var pulse = is_sel ? (sin(current_time/200)*5) : 0;
            
            var col = is_sel ? c_orange : c_dkgray;
            draw_set_color(col);
            draw_rectangle(box_x - pulse, box_y - pulse, box_x + 500 + pulse, box_y + 120 + pulse, false);
            
            var p_data = obj_game_data.player_team[i];
            draw_set_color(c_white);
            
            if (p_data != undefined) {
                draw_text(box_x + 20, box_y + 20, p_data.nickname);
                draw_text(box_x + 20, box_y + 60, "Lv. 50 " + string(p_data.types));
                
                // Remove Button
                if (draw_button_juicy(box_x+400, box_y+20, 80, 80, "X", mx, my, click)) {
                    obj_game_data.player_team[i] = undefined;
                }
                
                // Select Slot Logic
                if (point_in_rectangle(mx, my, box_x, box_y, box_x+400, box_y+120) && click) {
                    selected_slot = i;
                }
            } else {
                draw_text(box_x + 20, box_y + 40, "EMPTY SLOT");
                if (point_in_rectangle(mx, my, box_x, box_y, box_x+500, box_y+120) && click) {
                    selected_slot = i;
                }
            }
        }
        
        // --- RIGHT: DATABASE TABS ---
        var tab_w = 300; var tab_h = 60;
        var tab_x_start = 800;
        
        // Tab 1: Gen 1
        if (draw_button_juicy(tab_x_start, 50, tab_w, tab_h, "GEN 1", mx, my, click)) { current_tab = 0; scroll_offset = 0; }
        if (current_tab == 0) { draw_set_color(c_lime); draw_rectangle(tab_x_start, 110, tab_x_start+tab_w, 115, false); }
        
        // Tab 2: Gen 2
        if (draw_button_juicy(tab_x_start+310, 50, tab_w, tab_h, "GEN 2", mx, my, click)) { current_tab = 1; scroll_offset = 0; }
        if (current_tab == 1) { draw_set_color(c_lime); draw_rectangle(tab_x_start+310, 110, tab_x_start+310+tab_w, 115, false); }
        
        // Tab 3: Gen 3
        if (draw_button_juicy(tab_x_start+620, 50, tab_w, tab_h, "GEN 3", mx, my, click)) { current_tab = 2; scroll_offset = 0; }
        if (current_tab == 2) { draw_set_color(c_lime); draw_rectangle(tab_x_start+620, 110, tab_x_start+620+tab_w, 115, false); }

        // --- RIGHT: POKEMON LIST ---
        draw_set_color(c_dkgray); draw_rectangle(800, 120, 1800, 1000, false);
        
        // Calculate Filtered Range
        var start_index_master = 0;
        var end_index_master = 0;
        
        if (current_tab == 0) { start_index_master = 0; end_index_master = 12; }
        else if (current_tab == 1) { start_index_master = 12; end_index_master = 24; }
        else if (current_tab == 2) { start_index_master = 24; end_index_master = 36; }
        
        // Apply Scroll to the view
        var list_subset_len = end_index_master - start_index_master;
        
        // Draw List
        for (var j = 0; j < items_per_page; j++) {
            var actual_list_idx = start_index_master + scroll_offset + j;
            
            if (actual_list_idx >= end_index_master) break; // End of gen
            
            var name_str = obj_game_data.all_species_ids[actual_list_idx];
            var ly = 140 + (j * 60);
            
            // List Item Button
            // If we are currently selecting a slot, make these buttons green/active
            if (selected_slot != -1) {
                if (draw_button_juicy(820, ly, 900, 50, name_str, mx, my, click)) {
                    // ASSIGN
                    with(obj_game_data) set_player_slot(other.selected_slot, name_str);
                    // Juice: Small shake or flash? Handled by button function
                }
            } else {
                // Just Draw Text if no slot selected
                draw_set_color(c_black); draw_rectangle(820, ly, 1720, ly+50, false);
                draw_set_color(c_gray); draw_text(840, ly+10, name_str);
            }
        }
        
        // Back Button
        if (draw_button_juicy(50, 1000, 200, 60, "BACK", mx, my, click)) {
            state = MENU_STATE.MAIN;
        }
        break;

    // ============================================================
    // MODE SELECT
    // ============================================================
    case MENU_STATE.MODE_SELECT:
        draw_set_color(c_dkgray); draw_rectangle(0,0,1920,1080,false);
        draw_set_halign(fa_center); draw_set_color(c_white);
        draw_text(960, 200, "SELECT GAME MODE");
        
        if (draw_button_juicy(860, 400, 200, 80, "LOCAL BATTLE", mx, my, click)) {
            var valid = false;
            for(var i=0; i<6; i++) if (obj_game_data.player_team[i] != undefined) valid = true;
            
            if (valid) {
                obj_game_data.prepare_local_battle();
                obj_game_data.game_mode = "LOCAL";
                room_goto(rm_battle);
            } else {
                draw_set_color(c_red); draw_text(960, 350, "TEAM IS EMPTY!");
            }
        }
        
        if (draw_button_juicy(860, 800, 200, 80, "BACK", mx, my, click)) {
            state = MENU_STATE.MAIN;
        }
        draw_set_halign(fa_left);
        break;
}