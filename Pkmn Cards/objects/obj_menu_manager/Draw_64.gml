draw_set_font(menu_font);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var click = mouse_check_button_pressed(mb_left);

// Background (Global for all menus)
draw_set_color(c_dkgray); 
draw_rectangle(0,0,1920,1080,false);

switch(state) {
    
    // ============================================================
    // MAIN MENU
    // ============================================================
    case MENU_STATE.MAIN:
        draw_set_halign(fa_center); draw_set_color(c_white);
        draw_text_transformed(960, 200, "POKÉMON CARDS BATTLE", 2, 2, 0);
        
        if (draw_button_juicy(860, 500, 200, 80, "PLAY", mx, my, click)) {
            state = MENU_STATE.MODE_SELECT;
        }
        if (draw_button_juicy(860, 650, 200, 80, "TEAM BUILDER", mx, my, click)) {
            state = MENU_STATE.TEAM_BUILDER;
            selected_slot = -1; scroll_offset = 0;
        }
        if (draw_button_juicy(860, 800, 200, 80, "QUIT", mx, my, click)) {
            game_end();
        }
        break;

    // ============================================================
    // MODE SELECT (Updated with Online)
    // ============================================================
    case MENU_STATE.MODE_SELECT:
        draw_set_halign(fa_center); draw_set_color(c_white);
        draw_text(960, 200, "SELECT GAME MODE");
        
        // 1. LOCAL BATTLE (vs AI)
        if (draw_button_juicy(860, 400, 200, 80, "VS AI (LOCAL)", mx, my, click)) {
            if (check_team_valid()) {
                obj_game_data.prepare_local_battle();
                obj_game_data.game_mode = "LOCAL";
                room_goto(rm_battle);
            }
        }
        
        // 2. ONLINE / LAN
        if (draw_button_juicy(860, 550, 200, 80, "ONLINE / LAN", mx, my, click)) {
             if (check_team_valid()) {
                state = MENU_STATE.ONLINE_LOBBY;
                // Reset IP typing stuff
                is_typing_ip = false;
                keyboard_string = "";
             }
        }
        
        // BACK
        if (draw_button_juicy(860, 800, 200, 80, "BACK", mx, my, click)) {
            state = MENU_STATE.MAIN;
        }
        
        // Validation Warning
        if (!check_team_valid()) {
            draw_set_color(c_red); draw_text(960, 300, "TEAM IS EMPTY! GO TO BUILDER.");
        }
        draw_set_halign(fa_left);
        break;

    // ============================================================
    // ONLINE LOBBY (New)
    // ============================================================
    case MENU_STATE.ONLINE_LOBBY:
        draw_set_halign(fa_center); draw_set_color(c_white);
        draw_text(960, 150, "MULTIPLAYER LOBBY");
        draw_text(960, 200, "(Direct IP Connection)");
        
        // --- HOST BUTTON ---
        draw_text(960, 350, "Option A: Host a Game");
        if (draw_button_juicy(860, 400, 200, 80, "HOST SERVER", mx, my, click)) {
            // Create Network Manager as HOST
            if (!instance_exists(obj_network_manager)) {
                var net = instance_create_depth(0,0,0, obj_network_manager);
                net.is_server = true;
                net.start_server(7777); // Port 7777
            }
            obj_game_data.game_mode = "ONLINE";
            room_goto(rm_battle); // Go to battle room to wait for connection
        }
        
        // --- JOIN BUTTON ---
        draw_text(960, 600, "Option B: Join a Game");
        
        // IP Input Box
        var ip_col = is_typing_ip ? c_white : c_gray;
        draw_set_color(ip_col); draw_rectangle(810, 640, 1110, 690, false); // Box
        draw_set_color(c_black); draw_text(960, 665, join_ip_string + (is_typing_ip ? "|" : ""));
        
        // Click to type
        if (point_in_rectangle(mx, my, 810, 640, 1110, 690) && click) {
            is_typing_ip = true;
            keyboard_string = "";
        }
        
        if (draw_button_juicy(860, 720, 200, 80, "JOIN GAME", mx, my, click)) {
             // Create Network Manager as CLIENT
             if (!instance_exists(obj_network_manager)) {
                var net = instance_create_depth(0,0,0, obj_network_manager);
                net.is_server = false;
                net.connect_to_server(join_ip_string, 7777);
            }
            obj_game_data.game_mode = "ONLINE";
            room_goto(rm_battle);
        }

        // BACK
        if (draw_button_juicy(860, 900, 200, 80, "BACK", mx, my, click)) {
            state = MENU_STATE.MODE_SELECT;
        }
        draw_set_halign(fa_left);
        break;
        
    // ============================================================
    // TEAM BUILDER (Existing Code - Collapsed for brevity)
    // ============================================================
    case MENU_STATE.TEAM_BUILDER:
        // ... (Keep your existing Team Builder Draw Code exactly as it was) ...
        // I won't repeat the huge loop here to save space, but 
        // DO NOT DELETE IT. Paste your previous Team Builder code here.
        
        // Just ensuring the "Back" button goes to Main
        if (draw_button_juicy(50, 1000, 200, 60, "BACK", mx, my, click)) {
            state = MENU_STATE.MAIN;
        }
        
        // Render the builder...
        draw_team_builder(mx, my, click); // We'll move the logic to a helper function below
        break;
}

/// @func draw_team_builder(_mx, _my, _click)
/// Helper to keep the switch statement clean
function draw_team_builder(_mx, _my, _click) {
    // PASTE THE PREVIOUS TEAM BUILDER DRAW CODE HERE
    // (Everything from your previous "case MENU_STATE.TEAM_BUILDER")
    
    // --- LEFT: PLAYER TEAM ---
    draw_set_color(c_white); draw_text(50, 50, "YOUR TEAM");
    
    for(var i=0; i<6; i++) {
        var box_x = 100;
        var box_y = 150 + (i * 140);
        
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
            if (draw_button_juicy(box_x+400, box_y+20, 80, 80, "X", _mx, _my, _click)) {
                obj_game_data.player_team[i] = undefined;
            }
            if (point_in_rectangle(_mx, _my, box_x, box_y, box_x+400, box_y+120) && _click) selected_slot = i;
        } else {
            draw_text(box_x + 20, box_y + 40, "EMPTY SLOT");
            if (point_in_rectangle(_mx, _my, box_x, box_y, box_x+500, box_y+120) && _click) selected_slot = i;
        }
    }
    
    // --- RIGHT: DATABASE TABS ---
    var tab_w = 300; var tab_h = 60; var tab_x_start = 800;
    
    if (draw_button_juicy(tab_x_start, 50, tab_w, tab_h, "GEN 1", _mx, _my, _click)) { current_tab = 0; scroll_offset = 0; }
    if (current_tab == 0) { draw_set_color(c_lime); draw_rectangle(tab_x_start, 110, tab_x_start+tab_w, 115, false); }
    
    if (draw_button_juicy(tab_x_start+310, 50, tab_w, tab_h, "GEN 2", _mx, _my, _click)) { current_tab = 1; scroll_offset = 0; }
    if (current_tab == 1) { draw_set_color(c_lime); draw_rectangle(tab_x_start+310, 110, tab_x_start+310+tab_w, 115, false); }
    
    if (draw_button_juicy(tab_x_start+620, 50, tab_w, tab_h, "GEN 3", _mx, _my, _click)) { current_tab = 2; scroll_offset = 0; }
    if (current_tab == 2) { draw_set_color(c_lime); draw_rectangle(tab_x_start+620, 110, tab_x_start+620+tab_w, 115, false); }

    // --- RIGHT: POKEMON LIST ---
    draw_set_color(c_dkgray); draw_rectangle(800, 120, 1800, 1000, false);
    
    var start_index_master = 0; var end_index_master = 0;
    if (current_tab == 0) { start_index_master = 0; end_index_master = 12; }
    else if (current_tab == 1) { start_index_master = 12; end_index_master = 24; }
    else if (current_tab == 2) { start_index_master = 24; end_index_master = 36; }
    
    for (var j = 0; j < items_per_page; j++) {
        var actual_list_idx = start_index_master + scroll_offset + j;
        if (actual_list_idx >= end_index_master) break;
        
        var name_str = obj_game_data.all_species_ids[actual_list_idx];
        var ly = 140 + (j * 60);
        
        if (selected_slot != -1) {
            if (draw_button_juicy(820, ly, 900, 50, name_str, _mx, _my, _click)) {
                with(obj_game_data) set_player_slot(other.selected_slot, name_str);
            }
        } else {
            draw_set_color(c_black); draw_rectangle(820, ly, 1720, ly+50, false);
            draw_set_color(c_gray); draw_text(840, ly+10, name_str);
        }
    }
}

// Helper to check if team is valid
function check_team_valid() {
    for(var i=0; i<6; i++) {
        if (obj_game_data.player_team[i] != undefined) return true;
    }
    return false;
}