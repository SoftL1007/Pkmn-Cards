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
    // MODE SELECT
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
                is_typing_ip = false;
                keyboard_string = "";
             }
        }
        
        if (draw_button_juicy(860, 800, 200, 80, "BACK", mx, my, click)) {
            state = MENU_STATE.MAIN;
        }
        
        if (!check_team_valid()) {
            draw_set_color(c_red); draw_text(960, 300, "TEAM IS EMPTY! GO TO BUILDER.");
        }
        draw_set_halign(fa_left);
        break;

    // ============================================================
    // ONLINE LOBBY
    // ============================================================
    case MENU_STATE.ONLINE_LOBBY:
        draw_set_halign(fa_center); draw_set_color(c_white);
        draw_text(960, 150, "MULTIPLAYER LOBBY");
        draw_text(960, 200, "(Direct IP Connection)");
        
        draw_text(960, 350, "Option A: Host a Game");
        if (draw_button_juicy(860, 400, 200, 80, "HOST SERVER", mx, my, click)) {
            if (!instance_exists(obj_network_manager)) {
                var net = instance_create_depth(0,0,0, obj_network_manager);
                net.is_server = true;
                net.start_server(7777); 
            }
            obj_game_data.game_mode = "ONLINE";
            room_goto(rm_battle);
        }
        
        draw_text(960, 600, "Option B: Join a Game");
        var ip_col = is_typing_ip ? c_white : c_gray;
        draw_set_color(ip_col); draw_rectangle(810, 640, 1110, 690, false);
        draw_set_color(c_black); draw_text(960, 665, join_ip_string + (is_typing_ip ? "|" : ""));
        
        if (point_in_rectangle(mx, my, 810, 640, 1110, 690) && click) {
            is_typing_ip = true; keyboard_string = "";
        }
        
        if (draw_button_juicy(860, 720, 200, 80, "JOIN GAME", mx, my, click)) {
             if (!instance_exists(obj_network_manager)) {
                var net = instance_create_depth(0,0,0, obj_network_manager);
                net.is_server = false;
                net.connect_to_server(join_ip_string, 7777);
            }
            obj_game_data.game_mode = "ONLINE";
            room_goto(rm_battle);
        }

        if (draw_button_juicy(860, 900, 200, 80, "BACK", mx, my, click)) {
            state = MENU_STATE.MODE_SELECT;
        }
        draw_set_halign(fa_left);
        break;
        
    // ============================================================
    // TEAM BUILDER
    // ============================================================
    case MENU_STATE.TEAM_BUILDER:
        if (draw_button_juicy(50, 1000, 200, 60, "BACK", mx, my, click)) {
            state = MENU_STATE.MAIN;
        }
        draw_team_builder(mx, my, click);
        break;
}

// ----------------------------------------
// DRAW HELPER: TEAM BUILDER CONTENT
// ----------------------------------------
function draw_team_builder(_mx, _my, _click) {
    // 1. Draw Player Slots (Left Side)
    draw_set_color(c_white); draw_text(50, 50, "YOUR TEAM (Click X to remove)");
    
    for(var i=0; i<6; i++) {
        var box_x = 100;
        var box_y = 150 + (i * 140);
        var is_sel = (selected_slot == i);
        var pulse = is_sel ? (sin(current_time/200)*5) : 0;
        
        // Slot Background
        draw_set_color(is_sel ? c_orange : c_dkgray);
        draw_rectangle(box_x - pulse, box_y - pulse, box_x + 500 + pulse, box_y + 120 + pulse, false);
        
        var p_data = obj_game_data.player_team[i];
        
        if (p_data != undefined) {
            draw_set_color(c_white);
            draw_text(box_x + 20, box_y + 20, p_data.nickname);
            draw_text(box_x + 20, box_y + 60, "Lv. 50");
            
            // Delete Button (Small Red Box)
            var del_hover = point_in_rectangle(_mx, _my, box_x+400, box_y+20, box_x+450, box_y+70);
            draw_set_color(del_hover ? c_red : c_maroon);
            draw_rectangle(box_x+400, box_y+20, box_x+450, box_y+70, false);
            draw_set_color(c_white); draw_text(box_x+415, box_y+30, "X");
            
            if (del_hover && _click) obj_game_data.player_team[i] = undefined;
            if (!del_hover && point_in_rectangle(_mx, _my, box_x, box_y, box_x+400, box_y+120) && _click) selected_slot = i;
        } else {
            draw_set_color(c_white); draw_text(box_x + 20, box_y + 40, "EMPTY SLOT");
            if (point_in_rectangle(_mx, _my, box_x, box_y, box_x+500, box_y+120) && _click) selected_slot = i;
        }
    }
    
    // 2. Database Tabs (Right Side)
    var tab_w = 300; var tab_h = 60; var tab_x = 800;
    
    // Tab 1: Gen 1
    var t1_hover = draw_button_juicy(tab_x, 50, tab_w, tab_h, "GEN 1", _mx, _my, _click);
    if (t1_hover) { current_tab = 0; scroll_offset = 0; }
    if (current_tab == 0) { draw_set_color(c_lime); draw_rectangle(tab_x, 110, tab_x+tab_w, 115, false); }
    
    // Tab 2: Gen 2
    var t2_hover = draw_button_juicy(tab_x+310, 50, tab_w, tab_h, "GEN 2", _mx, _my, _click);
    if (t2_hover) { current_tab = 1; scroll_offset = 0; }
    if (current_tab == 1) { draw_set_color(c_lime); draw_rectangle(tab_x+310, 110, tab_x+310+tab_w, 115, false); }
    
    // Tab 3: Gen 3
    var t3_hover = draw_button_juicy(tab_x+620, 50, tab_w, tab_h, "GEN 3", _mx, _my, _click);
    if (t3_hover) { current_tab = 2; scroll_offset = 0; }
    if (current_tab == 2) { draw_set_color(c_lime); draw_rectangle(tab_x+620, 110, tab_x+620+tab_w, 115, false); }
    
    // 3. Database List
    draw_set_color(c_black); draw_set_alpha(0.5);
    draw_rectangle(800, 120, 1720, 1000, false); draw_set_alpha(1.0);
    
    var start_i = 0; var end_i = 0;
    if (current_tab == 0) { start_i = 0; end_i = 12; }      // Indices based on all_species_ids in Game Data
    if (current_tab == 1) { start_i = 12; end_i = 24; }
    if (current_tab == 2) { start_i = 24; end_i = 36; }
    
    var count = 0;
    for (var j = 0; j < items_per_page; j++) {
        var idx = start_i + scroll_offset + j;
        if (idx >= end_i) break;
        
        var s_id = obj_game_data.all_species_ids[idx];
        var s_data = get_pokemon_species(s_id); // Get name from ID
        var ly = 140 + (j * 70);
        
        // If we have a slot selected, this button assigns the Pokemon. Else, just viewing.
        if (selected_slot != -1) {
            if (draw_button_juicy(820, ly, 880, 60, string_upper(s_data.name), _mx, _my, _click)) {
                with(obj_game_data) set_player_slot(other.selected_slot, s_id);
            }
        } else {
            draw_set_color(c_gray); draw_rectangle(820, ly, 1700, ly+60, false);
            draw_set_color(c_white); draw_text(840, ly+20, string_upper(s_data.name));
        }
    }
}

// ----------------------------------------
// CHECK TEAM VALID
// ----------------------------------------
function check_team_valid() {
    for(var i=0; i<6; i++) {
        if (obj_game_data.player_team[i] != undefined) return true;
    }
    return false;
}