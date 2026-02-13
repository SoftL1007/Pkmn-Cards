if (!instance_exists(obj_battle_manager)) exit;
var mgr = obj_battle_manager;
var p_mon = mgr.player_pokemon;
var e_mon = mgr.enemy_pokemon;

draw_set_font(fnt_game); 

// --- 1. ENEMY HUD (Top Left - Fixed Coords) ---
// Swampert Position
draw_set_color(c_white);
draw_sprite_ext(spr_swampert_front, 0, 1200, 250, 2, 2, 0, c_white, 1); // x, y, scaleX, scaleY

// Info Box
draw_set_color(c_dkgray);
draw_rectangle(100, 50, 600, 180, false);
draw_set_color(c_white);
draw_text(120, 60, e_mon.species_name + " Lv." + string(e_mon.level));

// HP Bar Background
draw_set_color(c_black);
draw_rectangle(120, 100, 500, 130, false);
// HP Bar Foreground
var hp_pct = (e_mon.current_hp / e_mon.max_hp) * 100;
draw_healthbar(120, 100, 500, 130, hp_pct, c_black, c_red, c_green, 0, true, true);


// --- 2. PLAYER HUD (Bottom Left - Fixed Coords) ---
// Blaziken Position
draw_sprite_ext(spr_blaziken_back, 0, 400, 600, 2, 2, 0, c_white, 1);

// Info Box
draw_set_color(c_dkgray);
draw_rectangle(1000, 600, 1500, 750, false); // Bottom Right area
draw_set_color(c_white);
draw_text(1020, 620, p_mon.species_name + " Lv." + string(p_mon.level));
draw_text(1020, 660, string(p_mon.current_hp) + "/" + string(p_mon.max_hp));

// HP Bar
draw_healthbar(1020, 690, 1400, 720, (p_mon.current_hp / p_mon.max_hp)*100, c_black, c_red, c_green, 0, true, true);


// --- 3. BATTLE LOG (Bottom Center) ---
draw_set_color(c_black);
draw_rectangle(600, 850, 1320, 950, false); // Black box background
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(960, 880, mgr.battle_log);
draw_set_halign(fa_left);


// --- 4. PLAYER INPUT UI ---
if (mgr.state == BATTLE_STATE.INPUT_PHASE) {
    
    // MOVE BUTTONS (Bottom Row)
    for (var i = 0; i < array_length(p_mon.moves); i++) {
        var mx = 100 + (i * 300); // Spread them out more
        var my = 900;
        
        // Color based on selection
        if (mgr.selected_move == i) draw_set_color(c_yellow);
        else draw_set_color(c_gray);
        
        // Button Rect
        draw_rectangle(mx, my, mx+280, my+80, false);
        
        // Text
        draw_set_color(c_black);
        draw_text(mx+20, my+20, p_mon.moves[i].name);
        draw_text(mx+20, my+50, "PP: " + string(p_mon.moves[i].pp));
        
        // Click Logic
        if (mouse_check_button_pressed(mb_left)) {
            var gui_mx = device_mouse_x_to_gui(0);
            var gui_my = device_mouse_y_to_gui(0);
            
            if (gui_mx > mx && gui_mx < mx+280 && gui_my > my && gui_my < my+80) {
                mgr.selected_move = i;
            }
        }
    }
    
    // CARD HAND (Vertical list on Right Side)
    for (var c = 0; c < array_length(mgr.player_hand); c++) {
        var card = mgr.player_hand[c];
        var cx = 1600;
        var cy = 100 + (c * 150); // Start from top right, go down
        
        if (mgr.selected_card == c) draw_set_color(c_aqua);
        else draw_set_color(c_ltgray);
        
        draw_rectangle(cx, cy, cx+250, cy+130, false);
        draw_set_color(c_black);
        draw_text(cx+10, cy+10, card.name);
        draw_text_ext(cx+10, cy+40, card.description, 20, 230);
        
        if (mouse_check_button_pressed(mb_left)) {
            var gui_cx = device_mouse_x_to_gui(0);
            var gui_cy = device_mouse_y_to_gui(0);
            
            if (gui_cx > cx && gui_cx < cx+250 && gui_cy > cy && gui_cy < cy+130) {
                // Toggle
                if (mgr.selected_card == c) mgr.selected_card = -1;
                else mgr.selected_card = c;
            }
        }
    }
    
    // FIGHT BUTTON (Center Screen overlay)
    if (mgr.selected_move != -1) {
        draw_set_color(c_lime);
        draw_rectangle(860, 450, 1060, 550, false); // Big button in middle
        draw_set_color(c_black);
        draw_set_halign(fa_center);
        draw_text(960, 490, "GO!");
        draw_set_halign(fa_left);
        
        if (mouse_check_button_pressed(mb_left)) {
            var gui_bx = device_mouse_x_to_gui(0);
            var gui_by = device_mouse_y_to_gui(0);
             if (gui_bx > 860 && gui_bx < 1060 && gui_by > 450 && gui_by < 550) {
                mgr.state = BATTLE_STATE.RESOLVE_PHASE;
            }
        }
    }
}