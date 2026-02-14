// --------------------------------------------------------
// UI MANAGER - DRAW GUI (COMPLETE FIX)
// --------------------------------------------------------
if (!instance_exists(obj_battle_manager)) exit;
var mgr = obj_battle_manager;

// Safety Checks
if (mgr.p_active_index >= array_length(mgr.player_team)) exit;
if (mgr.e_active_index >= array_length(mgr.enemy_team)) exit;

var p_mon = mgr.player_team[mgr.p_active_index];
var e_mon = mgr.enemy_team[mgr.e_active_index];

draw_set_font(fnt_game);
var time_sec = current_time / 1000;
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

mgr.tooltip_text = ""; mgr.tooltip_header = "";

// 1. DIMMER & BG
if (mgr.bg_dim_alpha > 0) {
    draw_set_color(c_black); draw_set_alpha(mgr.bg_dim_alpha);
    draw_rectangle(0, 0, 1920, 1080, false); draw_set_alpha(1.0);
}

// 2. POKEMON SPRITES (Swapped assets back to User preference)
var shake_x = random_range(-mgr.screen_shake, mgr.screen_shake);
var shake_y = random_range(-mgr.screen_shake, mgr.screen_shake);

// --- ENEMY (Top Right, Back Sprite) ---
var e_draw_x = 1580 + shake_x + mgr.e_offset_x;
var e_draw_y = 950 + shake_y + mgr.e_offset_y; 
var e_shader_on = false;
if (e_mon.has_any_debuff()) { shader_set(shd_red_throb); shader_set_uniform_f(mgr.u_time_uni_debuff, time_sec); e_shader_on = true; } 
else if (e_mon.has_any_buff()) { shader_set(shd_buff); shader_set_uniform_f(mgr.u_time_uni_buff, time_sec); e_shader_on = true; }

// Use BACK sprite for Enemy
draw_sprite_ext(spr_pokemon_master_back, e_mon.sprite_frame, e_draw_x, e_draw_y, 2, 2, 0, c_white, 1);
if (e_shader_on) shader_reset();

if (mgr.e_flash_alpha > 0) {
    gpu_set_fog(true, c_white, 0, 0); 
    draw_sprite_ext(spr_pokemon_master_back, e_mon.sprite_frame, e_draw_x, e_draw_y, 2, 2, 0, c_white, mgr.e_flash_alpha);
    gpu_set_fog(false, c_white, 0, 0); 
}

// --- PLAYER (Bottom Left, Front Sprite) ---
var p_draw_x = 400 + shake_x + mgr.p_offset_x;
var p_draw_y = 1100 + shake_y + mgr.p_offset_y;
var p_shader_on = false;
if (p_mon.has_any_debuff()) { shader_set(shd_red_throb); shader_set_uniform_f(mgr.u_time_uni_debuff, time_sec); p_shader_on = true; } 
else if (p_mon.has_any_buff()) { shader_set(shd_buff); shader_set_uniform_f(mgr.u_time_uni_buff, time_sec); p_shader_on = true; }

// Use FRONT sprite for Player
draw_sprite_ext(spr_pokemon_master_front, p_mon.sprite_frame, p_draw_x, p_draw_y, 2.5, 2.5, 0, c_white, 1);
if (p_shader_on) shader_reset();

if (mgr.p_flash_alpha > 0) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(spr_pokemon_master_front, p_mon.sprite_frame, p_draw_x, p_draw_y, 2.5, 2.5, 0, c_white, mgr.p_flash_alpha);
    gpu_set_fog(false, c_white, 0, 0);
}

// 3. ANIMATION: ACTIVATED CARD (Center)
if (mgr.card_anim_active && mgr.card_anim_data != undefined) {
    var c = mgr.card_anim_data;
    var cy = mgr.card_anim_y;
    draw_set_alpha(0.5); draw_set_color(c_black); draw_circle(960, cy+10, 150, false); draw_set_alpha(1);
    draw_sprite_ext(spr_cards, c.icon_index, 960, cy, 3, 3, 0, c_white, 1);
    draw_set_halign(fa_center); draw_text(960, cy + 200, c.name); draw_set_halign(fa_left);
}

// 4. HUDS & ICONS
function draw_status_row(_mon, _x, _y) {
    var icon_idx = -1;
    switch(_mon.status_condition) {
        case "PAR": icon_idx=4; break;
        case "BRN": icon_idx=5; break;
        case "PSN": icon_idx=6; break;
        case "SLP": icon_idx=7; break;
    }
    if (icon_idx != -1) draw_sprite(spr_status_icons, icon_idx, _x, _y);
    
    var offset_x = (icon_idx != -1) ? 40 : 0;
    
    // Stats
    var stages = _mon.stat_stages;
    if (stages.atk > 0) draw_sprite(spr_status_icons, 0, _x+offset_x, _y); 
    if (stages.atk < 0) draw_sprite(spr_status_icons, 10, _x+offset_x, _y); offset_x+=40;
    
    if (stages.def > 0) draw_sprite(spr_status_icons, 1, _x+offset_x, _y); 
    if (stages.def < 0) draw_sprite(spr_status_icons, 11, _x+offset_x, _y); offset_x+=40;
    
    if (stages.spe > 0) draw_sprite(spr_status_icons, 3, _x+offset_x, _y); 
    if (stages.spe < 0) draw_sprite(spr_status_icons, 13, _x+offset_x, _y); offset_x+=40;
    
    if (_mon.active_trap != undefined) {
        draw_sprite_ext(spr_cards, _mon.active_trap.icon_index, _x+offset_x+20, _y, 0.4, 0.4, 0, c_white, 1);
    }
}

// ENEMY HUD
draw_set_color(c_white); draw_rectangle(50, 50, 600, 180, false);
draw_set_color(c_black); draw_rectangle(54, 54, 596, 176, false);
draw_set_color(c_white); draw_text(70, 65, e_mon.species_name + " Lv.50");
var e_hp_pct = (e_mon.display_hp / e_mon.max_hp) * 100;
draw_healthbar(70, 110, 550, 140, e_hp_pct, c_dkgray, c_red, c_lime, 0, true, true);
draw_status_row(e_mon, 70, 155); 

// PLAYER HUD
draw_set_color(c_white); draw_rectangle(1250, 650, 1850, 800, false);
draw_set_color(c_black); draw_rectangle(1254, 654, 1846, 796, false);
draw_set_color(c_white); draw_text(1270, 670, p_mon.species_name + " Lv.50");
draw_set_color(c_ltgray); draw_text(1270, 700, string(ceil(p_mon.display_hp)) + " / " + string(p_mon.max_hp));
var p_hp_pct = (p_mon.display_hp / p_mon.max_hp) * 100;
draw_healthbar(1350, 730, 1800, 760, p_hp_pct, c_dkgray, c_red, c_lime, 0, true, true);
// FIXED: Move icons to 1260 (Left)
draw_status_row(p_mon, 1260, 775);

// 5. BATTLE LOG
draw_set_color(c_white); draw_rectangle(0, 846, 1920, 850, false);
draw_set_color(c_black); draw_rectangle(0, 850, 1920, 1080, false);
draw_set_color(c_white); draw_set_halign(fa_center);
draw_text_ext(960, 910, mgr.battle_log_display, 50, 1600);
draw_set_halign(fa_left);

// 6. UI ELEMENTS (State Dependent)
// RESTORED: Turn Decision / Discard / Switch / Revive / Input
if (mgr.state == BATTLE_STATE.TURN_START_DECISION) {
    draw_set_color(c_black); draw_set_alpha(0.8); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_color(c_white); draw_text(960, 400, "DRAW PHASE");
    draw_text(960, 450, "Draw a new card?");
    
    var h_yes = point_in_rectangle(mx, my, 760, 500, 910, 580);
    draw_set_color(h_yes ? c_lime : c_white); draw_rectangle(760, 500, 910, 580, false);
    draw_set_color(c_black); draw_text(810, 520, "YES");
    
    var h_no = point_in_rectangle(mx, my, 1010, 500, 1160, 580);
    draw_set_color(h_no ? c_red : c_white); draw_rectangle(1010, 500, 1160, 580, false);
    draw_set_color(c_black); draw_text(1060, 520, "NO");
    draw_set_halign(fa_left);
}
else if (mgr.state == BATTLE_STATE.DISCARD_CHOICE) {
    draw_set_color(c_black); draw_set_alpha(0.8); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_color(c_white); draw_text(960, 200, "DISCARD ONE CARD");
    draw_set_halign(fa_left);
    
    for (var c = 0; c < array_length(mgr.player_hand); c++) {
        var card = mgr.player_hand[c];
        var cx = 600 + (c * 150); 
        var hover = point_in_rectangle(mx, my, cx, 400, cx+140, 600);
        
        draw_set_color(hover ? c_red : c_white);
        draw_rectangle(cx, 400, cx+140, 600, false);
        draw_sprite(spr_cards, card.icon_index, cx+70, 500);
    }
}
else if (mgr.state == BATTLE_STATE.SWITCH_MENU || mgr.state == BATTLE_STATE.REVIVE_MENU) {
    draw_set_color(c_black); draw_set_alpha(0.9); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    draw_set_color(c_white); draw_text(100, 100, (mgr.state==BATTLE_STATE.SWITCH_MENU)?"SWITCH":"REVIVE");
    
    for (var i = 0; i < array_length(mgr.player_team); i++) {
        var pm = mgr.player_team[i];
        var py = 200 + (i * 120);
        
        // Colors
        var is_active = (i == mgr.p_active_index);
        var is_dead = (pm.current_hp <= 0);
        var box_col = c_white;
        if (is_active) box_col = c_lime;
        if (is_dead) box_col = c_gray;
        
        if (point_in_rectangle(mx, my, 100, py, 600, py+100)) box_col = c_yellow;

        draw_set_color(box_col); draw_rectangle(96, py-4, 604, py+104, false);
        draw_set_color(c_black); draw_rectangle(100, py, 600, py+100, false);
        
        draw_set_color(c_white);
        if (is_dead) draw_set_color(c_red);
        draw_text(120, py+20, pm.nickname + " " + string(ceil(pm.display_hp)) + "/" + string(pm.max_hp));
    }
    draw_set_color(c_red); draw_rectangle(700, 900, 900, 1000, false);
    draw_set_color(c_white); draw_text(740, 940, "CANCEL");
}
else if (mgr.state == BATTLE_STATE.INPUT_PHASE) {
    
    // Moves
    for (var i = 0; i < array_length(p_mon.moves); i++) {
        var row = floor(i / 2); var col = i % 2;
        var btn_x = 50 + (col * 320); var btn_y = 870 + (row * 100);
        var mv = p_mon.moves[i];
        var hover = point_in_rectangle(mx, my, btn_x, btn_y, btn_x+300, btn_y+90);
        
        var border = (mgr.selected_move == i) ? c_lime : c_white;
        if (hover) border = c_yellow;
        
        draw_set_color(border); draw_rectangle(btn_x-4, btn_y-4, btn_x+304, btn_y+94, false);
        draw_set_color(c_dkgray); draw_rectangle(btn_x, btn_y, btn_x+300, btn_y+90, false);
        draw_set_color(c_white); draw_text(btn_x+10, btn_y+10, mv.name);
        
        if (hover) {
            mgr.tooltip_header = mv.name;
            var cat_str = get_gen3_category(mv.type);
            mgr.tooltip_text = "Type: " + string(mv.type) + "\nPow: " + string(mv.base_power) + "\nAcc: " + string(mv.accuracy) + "\n" + cat_str;
        }
    }
    
    // Hand (LERPED Y VISUALS)
    var hand_size = array_length(mgr.player_hand);
    var start_x = 1550 - ((hand_size - 1) * 90); 
    
    for (var c = 0; c < hand_size; c++) {
        var card = mgr.player_hand[c];
        var cx = start_x + (c * 180);
        
        // Use the LERPED y position from manager
        var cy = mgr.hand_visual_y[c]; 
        
        var hover = point_in_rectangle(mx, my, cx - 60, 750, cx + 60, 1080);

        draw_sprite_ext(spr_cards, card.icon_index, cx, cy, 2.5, 2.5, 0, c_white, 1);

        if (mgr.selected_card == c) {
            draw_set_color(c_aqua); draw_set_alpha(0.5); draw_circle(cx, cy, 90, false); draw_set_alpha(1);
        }
        
        if (hover) {
             mgr.tooltip_header = card.name;
             // TYPE TO STRING FIX
             var type_str = "CARD";
             switch(card.type) {
                 case CARD_TYPE.MAGIC: type_str = "MAGIC"; break;
                 case CARD_TYPE.TRAP: type_str = "TRAP"; break;
                 case CARD_TYPE.EVENT: type_str = "EVENT"; break;
             }
             mgr.tooltip_text = card.description + "\n[" + type_str + "]";
        }
    }
    
    // EVENT CARD (RESTORED VISIBILITY)
    if (mgr.event_card_active != undefined) {
        var ec = mgr.event_card_active;
        var ex = 970; var ey = 260;
        var e_hover = point_in_rectangle(mx, my, ex-60, ey-80, ex+60, ey+80);
        
        // Glow if active/selected
        if (e_hover || mgr.selected_card == 100) {
            draw_set_alpha(0.5); draw_set_color(c_yellow); draw_circle(ex, ey, 80, false); draw_set_alpha(1);
        }
        draw_sprite_ext(spr_cards, ec.icon_index, ex, ey, 2.0, 2.0, 0, c_white, 1);
        
        // Tooltip for Event
        if (e_hover) {
             mgr.tooltip_header = ec.name;
             mgr.tooltip_text = ec.description + "\n[EVENT]";
        }
    }
    
    // SWITCH BUTTON
    draw_set_color(c_orange); draw_rectangle(50, 780, 250, 840, false);
    draw_set_color(c_black); draw_text(70, 800, "SWITCH");
    
    // SHUFFLE BUTTON (RESTORED VISIBILITY)
    if (mgr.mulligan_available) {
        var h_shuff = point_in_rectangle(mx, my, 860, 20, 1060, 100);
        draw_set_color(h_shuff ? c_purple : c_dkgray); 
        draw_rectangle(860, 20, 1060, 100, false);
        draw_set_color(c_white); 
        draw_text(900, 50, "RESHUFFLE");
    }
    
    // GO Button (Shows if ANY selected)
    if (mgr.selected_move != -1 || mgr.selected_card != -1) {
        draw_set_color(c_lime); draw_rectangle(860, 780, 1060, 840, false);
        draw_set_color(c_black); draw_set_halign(fa_center); draw_text(960, 800, "GO!"); draw_set_halign(fa_left);
    }
}

// Tooltip Render
if (mgr.tooltip_text != "") {
    var tw = string_width(mgr.tooltip_text) + 40;
    var th = string_height(mgr.tooltip_text) + 60;
    var tx = mx + 20; var ty = my - th - 20;
    if (tx + tw > 1920) tx = mx - tw - 20;
    if (ty < 0) ty = my + 20;
    
    draw_set_color(c_black); draw_set_alpha(0.9); draw_roundrect(tx, ty, tx+tw, ty+th, false); draw_set_alpha(1.0);
    draw_set_color(c_white); draw_roundrect(tx, ty, tx+tw, ty+th, true);
    draw_set_color(c_yellow); draw_text(tx+15, ty+10, mgr.tooltip_header);
    draw_set_color(c_white); draw_text(tx+15, ty+45, mgr.tooltip_text);
}