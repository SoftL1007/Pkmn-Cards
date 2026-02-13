if (!instance_exists(obj_battle_manager)) exit;
var mgr = obj_battle_manager;

// Get Active Pokemon
var p_mon = mgr.player_team[mgr.p_active_index];
var e_mon = mgr.enemy_team[mgr.e_active_index];

draw_set_font(fnt_game);

// --- CALCULATE SHAKE ---
var shake_x = random_range(-mgr.screen_shake, mgr.screen_shake);
var shake_y = random_range(-mgr.screen_shake, mgr.screen_shake);


// --- 1. ENEMY RENDER (Top Left - Fixed Coords) ---
// Standard: Enemy uses FRONT sprite.
// Applied Animation: Shake + Lunge Offset (e_offset_x) + Flash
var e_draw_x = 1480 + shake_x + mgr.e_offset_x;
var e_draw_y = 1100 + shake_y + mgr.e_offset_y;

// Draw Sprite
draw_sprite_ext(spr_pokemon_master_back, e_mon.sprite_frame, e_draw_x, e_draw_y, 2, 2, 0, c_white, 1);

// Draw Flash Overlay (White silhouette when hit)
if (mgr.e_flash_alpha > 0) {
    gpu_set_fog(true, c_white, 0, 0); // Turn everything white
    draw_sprite_ext(spr_pokemon_master_front, e_mon.sprite_frame, e_draw_x, e_draw_y, 2, 2, 0, c_white, mgr.e_flash_alpha);
    gpu_set_fog(false, c_white, 0, 0); // Turn off
}

// Enemy Info Box
draw_set_color(c_dkgray);
draw_rectangle(0, 0, 600, 140, false);
draw_set_color(c_white);
draw_text(20, 10, e_mon.species_name + " Lv." + string(e_mon.level));

// Enemy HP Bar
draw_set_color(c_black);
draw_rectangle(20, 50, 500, 80, false);
var hp_pct_e = (e_mon.current_hp / e_mon.max_hp) * 100;
draw_healthbar(20, 50, 500, 80, hp_pct_e, c_black, c_red, c_green, 0, true, true);


// --- 2. PLAYER RENDER (Bottom Left - Fixed Coords) ---
// Standard: Player uses BACK sprite.
// Applied Animation: Shake + Lunge Offset (p_offset_x)
var p_draw_x = 400 + shake_x + mgr.p_offset_x;
var p_draw_y = 1100 + shake_y + mgr.p_offset_y;

draw_sprite_ext(spr_pokemon_master_front, p_mon.sprite_frame, p_draw_x, p_draw_y, 2, 2, 0, c_white, 1);

// Draw Flash Overlay
if (mgr.p_flash_alpha > 0) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(spr_pokemon_master_front, p_mon.sprite_frame, p_draw_x, p_draw_y, 2, 2, 0, c_white, mgr.p_flash_alpha);
    gpu_set_fog(false, c_white, 0, 0);
}

// Player Info Box
draw_set_color(c_dkgray);
draw_rectangle(1300, 700, 1920, 850, false);
draw_set_color(c_white);
draw_text(1320, 710, p_mon.species_name + " Lv." + string(p_mon.level));
draw_text(1320, 740, string(p_mon.current_hp) + "/" + string(p_mon.max_hp));

// Player HP Bar
draw_healthbar(1400, 770, 1800, 810, (p_mon.current_hp / p_mon.max_hp)*100, c_black, c_red, c_green, 0, true, true);


// --- 3. BATTLE LOG ---
draw_set_color(c_black);
draw_rectangle(0, 850, 1920, 1080, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(960, 880, mgr.battle_log);
draw_set_halign(fa_left);


// --- 4. PLAYER INPUT UI ---
if (mgr.state == BATTLE_STATE.INPUT_PHASE) {
    
    // MOVE BUTTONS
    for (var i = 0; i < array_length(p_mon.moves); i++) {
        var mx = 360 + (i * 300);
        var my = 950;
        
        if (mgr.selected_move == i) draw_set_color(c_yellow);
        else draw_set_color(c_gray);
        
        draw_rectangle(mx, my, mx+280, my+80, false);
        
        draw_set_color(c_black);
        draw_text(mx+20, my+20, p_mon.moves[i].name);
        draw_text(mx+20, my+50, "PP: " + string(p_mon.moves[i].pp));
        
        if (mouse_check_button_pressed(mb_left)) {
            var gui_mx = device_mouse_x_to_gui(0);
            var gui_my = device_mouse_y_to_gui(0);
            if (gui_mx > mx && gui_mx < mx+280 && gui_my > my && gui_my < my+80) {
                mgr.selected_move = i;
            }
        }
    }
    
    // CARD HAND
    for (var c = 0; c < array_length(mgr.player_hand); c++) {
        var card = mgr.player_hand[c];
        var cx = 1650;
        var cy = 20 + (c * 150);
        
        if (mgr.selected_card == c) draw_set_color(c_aqua);
        else draw_set_color(c_dkgray);
        
        draw_rectangle(cx, cy, cx+250, cy+130, false);
        draw_set_color(c_white);
        draw_text(cx+10, cy+10, card.name);
        draw_text_ext(cx+10, cy+40, card.description, 20, 230);
        
        if (mouse_check_button_pressed(mb_left)) {
            var gui_cx = device_mouse_x_to_gui(0);
            var gui_cy = device_mouse_y_to_gui(0);
            if (gui_cx > cx && gui_cx < cx+250 && gui_cy > cy && gui_cy < cy+130) {
                // Toggle card logic
                if (mgr.selected_card == c) mgr.selected_card = -1;
                else mgr.selected_card = c;
            }
        }
    }
    
    // GO BUTTON
    if (mgr.selected_move != -1) {
        draw_set_color(c_lime);
        draw_rectangle(860, 450, 1060, 550, false);
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