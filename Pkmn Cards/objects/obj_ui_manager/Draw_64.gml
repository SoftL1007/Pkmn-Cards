if (!instance_exists(obj_battle_manager)) exit;
var mgr = obj_battle_manager;

var p_mon = mgr.player_team[mgr.p_active_index];
var e_mon = mgr.enemy_team[mgr.e_active_index];

draw_set_font(fnt_game);

// Global Time for Shader Animation
var time_sec = current_time / 1000;

// CYCLE ICON LOGIC (Switch every 1.5 seconds)
// We check 0=Atk, 1=Def, 2=Spe (Indices of your sprite)
var cycle_index = floor(time_sec / 1.5) % 3; 
var icon_map = ["atk", "def", "spe"];
var current_stat_key = icon_map[cycle_index];

// ------------------------------------------------
// ENEMY RENDER
// ------------------------------------------------
var shake_x = random_range(-mgr.screen_shake, mgr.screen_shake);
var shake_y = random_range(-mgr.screen_shake, mgr.screen_shake);
var e_draw_x = 1480 + shake_x + mgr.e_offset_x;
var e_draw_y = 1100 + shake_y + mgr.e_offset_y;

// Check Enemy Stage for current cycle stat
var e_stage = variable_struct_get(e_mon.stat_stages, current_stat_key);

// SHADER APPLICATION
if (e_stage > 0) {
    shader_set(shd_buff);
    shader_set_uniform_f(mgr.u_time_uni_buff, time_sec);
} else if (e_stage < 0) {
    shader_set(shd_debuff);
    shader_set_uniform_f(mgr.u_time_uni_debuff, time_sec);
}

draw_sprite_ext(spr_pokemon_master_back, e_mon.sprite_frame, e_draw_x, e_draw_y, 2, 2, 0, c_white, 1);
shader_reset();

// ICON APPLICATION
if (e_stage != 0) {
    // Draw the icon corresponding to cycle_index
    // Ensure coordinates are visible (Top Right of sprite)
    draw_sprite_ext(spr_status_icons, cycle_index, e_draw_x + 100, e_draw_y - 150, 2, 2, 0, c_white, 1);
    
    // Optional: Draw stage number (e.g. +2)
    draw_set_color(c_white);
    var sign_str = (e_stage > 0) ? "+" : "";
    draw_text(e_draw_x + 140, e_draw_y - 150, sign_str + string(e_stage));
}

// Flash
if (mgr.e_flash_alpha > 0) {
    gpu_set_fog(true, c_white, 0, 0); 
    draw_sprite_ext(spr_pokemon_master_front, e_mon.sprite_frame, e_draw_x, e_draw_y, 2, 2, 0, c_white, mgr.e_flash_alpha);
    gpu_set_fog(false, c_white, 0, 0); 
}

// Enemy UI
draw_set_color(c_dkgray);
draw_rectangle(0, 0, 600, 140, false);
draw_set_color(c_white);
draw_text(20, 10, e_mon.species_name + " Lv." + string(e_mon.level));
draw_set_color(c_black);
draw_rectangle(20, 50, 500, 80, false);
draw_healthbar(20, 50, 500, 80, (e_mon.current_hp / e_mon.max_hp) * 100, c_black, c_red, c_green, 0, true, true);


// ------------------------------------------------
// PLAYER RENDER
// ------------------------------------------------
var p_draw_x = 400 + shake_x + mgr.p_offset_x;
var p_draw_y = 1100 + shake_y + mgr.p_offset_y;

// Check Player Stage for current cycle stat
var p_stage = variable_struct_get(p_mon.stat_stages, current_stat_key);
// Check Player Card Buffs for current cycle
var p_card_buff = variable_struct_get(p_mon.card_buffs, current_stat_key);

// SHADER: Logic = If Stage != 0 OR Card Buff active (> 1.0)
var p_show_buff = (p_stage > 0 || p_card_buff > 1.0);
var p_show_debuff = (p_stage < 0);

if (p_show_buff) {
    shader_set(shd_buff);
    shader_set_uniform_f(mgr.u_time_uni_buff, time_sec);
} else if (p_show_debuff) {
    shader_set(shd_debuff);
    shader_set_uniform_f(mgr.u_time_uni_debuff, time_sec);
}

draw_sprite_ext(spr_pokemon_master_front, p_mon.sprite_frame, p_draw_x, p_draw_y, 2, 2, 0, c_white, 1);
shader_reset();

// ICON APPLICATION
if (p_show_buff || p_show_debuff) {
    draw_sprite_ext(spr_status_icons, cycle_index, p_draw_x + 100, p_draw_y - 200, 2, 2, 0, c_white, 1);
    
    // Draw stage text
    draw_set_color(c_white);
    var txt = "";
    if (p_stage != 0) txt = (p_stage > 0 ? "+" : "") + string(p_stage);
    else if (p_card_buff > 1.0) txt = "+Temp"; // Indicate card buff
    
    draw_text(p_draw_x + 140, p_draw_y - 200, txt);
}

// Flash
if (mgr.p_flash_alpha > 0) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(spr_pokemon_master_front, p_mon.sprite_frame, p_draw_x, p_draw_y, 2, 2, 0, c_white, mgr.p_flash_alpha);
    gpu_set_fog(false, c_white, 0, 0);
}

// Player UI
draw_set_color(c_dkgray);
draw_rectangle(1300, 700, 1920, 850, false);
draw_set_color(c_white);
draw_text(1320, 710, p_mon.species_name + " Lv." + string(p_mon.level));
draw_text(1320, 740, string(p_mon.current_hp) + "/" + string(p_mon.max_hp));
draw_healthbar(1400, 770, 1800, 810, (p_mon.current_hp / p_mon.max_hp)*100, c_black, c_red, c_green, 0, true, true);


// ------------------------------------------------
// LOG & INPUT
// ------------------------------------------------
draw_set_color(c_black);
draw_rectangle(0, 850, 1920, 1080, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(960, 880, mgr.battle_log);
draw_set_halign(fa_left);

if (mgr.state == BATTLE_STATE.INPUT_PHASE) {
    // Moves
    for (var i = 0; i < array_length(p_mon.moves); i++) {
        var mx = 360 + (i * 300);
        var my = 950;
        if (mgr.selected_move == i) draw_set_color(c_yellow); else draw_set_color(c_gray);
        draw_rectangle(mx, my, mx+280, my+80, false);
        draw_set_color(c_black);
        draw_text(mx+20, my+20, p_mon.moves[i].name);
        draw_text(mx+20, my+50, "PP: " + string(p_mon.moves[i].pp));
        
        if (mouse_check_button_pressed(mb_left)) {
            var gui_mx = device_mouse_x_to_gui(0);
            var gui_my = device_mouse_y_to_gui(0);
            if (gui_mx > mx && gui_mx < mx+280 && gui_my > my && gui_my < my+80) mgr.selected_move = i;
        }
    }
    
    // Cards
    for (var c = 0; c < array_length(mgr.player_hand); c++) {
        var card = mgr.player_hand[c];
        var cx = 1650; var cy = 20 + (c * 150);
        if (mgr.selected_card == c) draw_set_color(c_aqua); else draw_set_color(c_dkgray);
        draw_rectangle(cx, cy, cx+250, cy+130, false);
        draw_set_color(c_white);
        draw_text(cx+10, cy+10, card.name);
        draw_text_ext(cx+10, cy+40, card.description, 20, 230);
        
        if (mouse_check_button_pressed(mb_left)) {
            var gui_cx = device_mouse_x_to_gui(0);
            var gui_cy = device_mouse_y_to_gui(0);
            if (gui_cx > cx && gui_cx < cx+250 && gui_cy > cy && gui_cy < cy+130) {
                if (mgr.selected_card == c) mgr.selected_card = -1; else mgr.selected_card = c;
            }
        }
    }
    
    // GO Button
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
            if (gui_bx > 860 && gui_bx < 1060 && gui_by > 450 && gui_by < 550) mgr.state = BATTLE_STATE.RESOLVE_PHASE;
        }
    }
}