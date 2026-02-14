// --------------------------------------------------------
// UI MANAGER - DRAW GUI (FINAL FIXED VERSION)
// --------------------------------------------------------

if (!instance_exists(obj_battle_manager)) exit;
var mgr = obj_battle_manager;

// Safety Checks (Stop crash if teams aren't loaded)
if (mgr.p_active_index >= array_length(mgr.player_team)) exit;
if (mgr.e_active_index >= array_length(mgr.enemy_team)) exit;

var p_mon = mgr.player_team[mgr.p_active_index];
var e_mon = mgr.enemy_team[mgr.e_active_index];

// 0. DEFINITIONS
var type_names = ["NORMAL", "FIRE", "WATER", "GRASS", "ELECTRIC", "ICE", "FIGHTING", "POISON", "GROUND", "FLYING", "PSYCHIC", "BUG", "ROCK", "GHOST", "DRAGON", "STEEL", "DARK", "NONE"];

draw_set_font(fnt_game);
var time_sec = current_time / 1000;
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Clear Tooltip variables
mgr.tooltip_text = ""; 
mgr.tooltip_header = "";

// 1. DIMMER & BG
if (mgr.bg_dim_alpha > 0) {
    draw_set_color(c_black); draw_set_alpha(mgr.bg_dim_alpha);
    draw_rectangle(0, 0, 1920, 1080, false); draw_set_alpha(1.0);
}

// 2. POKEMON SPRITES & SHADERS
var shake_x = random_range(-mgr.screen_shake, mgr.screen_shake);
var shake_y = random_range(-mgr.screen_shake, mgr.screen_shake);

// Determine Switch Actor
var is_switching = (mgr.state == BATTLE_STATE.ANIMATION_SWITCH);
var switch_actor = (is_switching) ? mgr.switch_processing_actor : "none";

// --- ENEMY ---
var e_draw_x = 1580 + shake_x + mgr.e_offset_x;
var e_draw_y = 950 + shake_y + mgr.e_offset_y; 
var e_sc = variable_instance_exists(mgr, "e_scale") ? mgr.e_scale : 1.0;

// Shader Logic Enemy
var e_shader_on = false;
if (is_switching && switch_actor == "ENEMY") { 
    shader_set(shd_mirage); 
    shader_set_uniform_f(shader_get_uniform(shd_mirage, "u_time"), time_sec);
    e_shader_on = true;
} 
else if (e_mon.has_any_debuff()) { shader_set(shd_red_throb); shader_set_uniform_f(mgr.u_time_uni_debuff, time_sec); e_shader_on = true; } 
else if (e_mon.has_any_buff()) { shader_set(shd_buff); shader_set_uniform_f(mgr.u_time_uni_buff, time_sec); e_shader_on = true; }

draw_sprite_ext(spr_pokemon_master_back, e_mon.sprite_frame, e_draw_x, e_draw_y, 2.0 * e_sc, 2.0 * e_sc, 0, c_white, 1);
if (e_shader_on) shader_reset(); 

if (mgr.e_flash_alpha > 0) { 
    gpu_set_fog(true, c_white, 0, 0); 
    draw_sprite_ext(spr_pokemon_master_back, e_mon.sprite_frame, e_draw_x, e_draw_y, 2.0 * e_sc, 2.0 * e_sc, 0, c_white, mgr.e_flash_alpha); 
    gpu_set_fog(false, c_white, 0, 0); 
}

// --- PLAYER ---
var p_draw_x = 400 + shake_x + mgr.p_offset_x;
var p_draw_y = 1100 + shake_y + mgr.p_offset_y;
var p_sc = variable_instance_exists(mgr, "p_scale") ? mgr.p_scale : 1.0;

// Shader Logic Player
var p_shader_on = false;
if (is_switching && switch_actor == "PLAYER") { 
    shader_set(shd_mirage); 
    shader_set_uniform_f(shader_get_uniform(shd_mirage, "u_time"), time_sec);
    p_shader_on = true;
} 
else if (p_mon.has_any_debuff()) { shader_set(shd_red_throb); shader_set_uniform_f(mgr.u_time_uni_debuff, time_sec); p_shader_on = true; } 
else if (p_mon.has_any_buff()) { shader_set(shd_buff); shader_set_uniform_f(mgr.u_time_uni_buff, time_sec); p_shader_on = true; }

draw_sprite_ext(spr_pokemon_master_front, p_mon.sprite_frame, p_draw_x, p_draw_y, 2.5 * p_sc, 2.5 * p_sc, 0, c_white, 1);
if (p_shader_on) shader_reset(); 

if (mgr.p_flash_alpha > 0) { 
    gpu_set_fog(true, c_white, 0, 0); 
    draw_sprite_ext(spr_pokemon_master_front, p_mon.sprite_frame, p_draw_x, p_draw_y, 2.5 * p_sc, 2.5 * p_sc, 0, c_white, mgr.p_flash_alpha); 
    gpu_set_fog(false, c_white, 0, 0); 
}

// 3. ANIMATION
if (mgr.card_anim_active && mgr.card_anim_data != undefined) {
    var c = mgr.card_anim_data; var cy = mgr.card_anim_y;
    draw_set_alpha(0.5); draw_set_color(c_black); draw_circle(960, cy+10, 150, false); draw_set_alpha(1);
    draw_sprite_ext(spr_cards, c.icon_index, 960, cy, 3, 3, 0, c_white, 1);
    draw_set_halign(fa_center); draw_text(960, cy + 200, c.name); draw_set_halign(fa_left);
}
if (variable_global_exists("part_sys") && part_system_exists(global.part_sys)) part_system_drawit(global.part_sys);

// 4. HUDS 
function draw_status_row_final(_mon, _x, _y) {
    var icon_idx = -1;
    switch(_mon.status_condition) { 
        case "PAR": icon_idx=10; break; 
        case "BRN": icon_idx=11; break; 
        case "PSN": icon_idx=12; break; 
        case "SLP": icon_idx=13; break; 
    }
    if (icon_idx != -1) draw_sprite(spr_status_icons, icon_idx, _x, _y);
    
    var offset_x = (icon_idx != -1) ? 40 : 0;
    var st = _mon.stat_stages;
    
    if (st.atk > 0) draw_sprite(spr_status_icons, 0, _x+offset_x, _y); 
    if (st.atk < 0) draw_sprite(spr_status_icons, 5, _x+offset_x, _y); 
    if (st.atk != 0) offset_x+=40;
    
    if (st.def > 0) draw_sprite(spr_status_icons, 1, _x+offset_x, _y); 
    if (st.def < 0) draw_sprite(spr_status_icons, 6, _x+offset_x, _y); 
    if (st.def != 0) offset_x+=40;
    
    if (st.spe > 0) draw_sprite(spr_status_icons, 2, _x+offset_x, _y); 
    if (st.spe < 0) draw_sprite(spr_status_icons, 7, _x+offset_x, _y); 
    if (st.spe != 0) offset_x+=40;
    
    if (st.spa > 0) draw_sprite(spr_status_icons, 3, _x+offset_x, _y); 
    if (st.spa < 0) draw_sprite(spr_status_icons, 8, _x+offset_x, _y); 
    if (st.spa != 0) offset_x+=40;
    
    if (st.spd > 0) draw_sprite(spr_status_icons, 4, _x+offset_x, _y); 
    if (st.spd < 0) draw_sprite(spr_status_icons, 9, _x+offset_x, _y); 
    if (st.spd != 0) offset_x+=40;

    if (_mon.active_trap != undefined) {
        draw_sprite_ext(spr_cards, _mon.active_trap.icon_index, _x+offset_x+20, _y, 0.4, 0.4, 0, c_white, 1);
    }
}

// Enemy HUD Update
draw_set_color(c_white); draw_text(70, 65, e_mon.species_name + " Lv.50");
// SAFETY: Check for display_hp, otherwise use current_hp
var ehp = variable_struct_exists(e_mon, "display_hp") ? e_mon.display_hp : e_mon.current_hp;
draw_healthbar(70, 110, 550, 140, (ehp / e_mon.max_hp) * 100, c_dkgray, c_red, c_lime, 0, true, true);
draw_status_row_final(e_mon, 70, 155); 

// Player HUD Update
draw_set_color(c_white); draw_text(1270, 670, p_mon.species_name + " Lv.50");
var php = variable_struct_exists(p_mon, "display_hp") ? p_mon.display_hp : p_mon.current_hp;
draw_set_color(c_ltgray); draw_text(1270, 710, string(ceil(php)) + " / " + string(p_mon.max_hp));
draw_healthbar(1350, 740, 1800, 770, (php / p_mon.max_hp) * 100, c_dkgray, c_red, c_lime, 0, true, true);
draw_status_row_final(p_mon, 1230, 775);

// 5. BATTLE LOG
draw_set_color(c_white); draw_rectangle(0, 846, 1920, 850, false);
draw_set_color(c_black); draw_rectangle(0, 850, 1920, 1080, false);
draw_set_color(c_white); draw_set_halign(fa_center);
draw_text_ext(960, 910, mgr.battle_log_display, 50, 1600);
draw_set_halign(fa_left);


// ============================================
// DISCARD CHOICE SCREEN (OVERHAUL + FIX)
// ============================================
if (mgr.state == BATTLE_STATE.DISCARD_CHOICE) {
    draw_set_color(c_black); draw_set_alpha(0.95); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    
    // INCOMING CARD
    if (array_length(mgr.player_deck) > 0) {
        var inc_card = get_card_data(mgr.player_deck[0]); 
        var show_x = 400; var show_y = 380 + sin(current_time / 200) * 10;
        
        draw_set_halign(fa_center);
        draw_set_color(c_lime); draw_text(show_x, show_y - 180, "NEW!");
        
        if (variable_global_exists("part_sys")) part_particles_create(global.part_sys, show_x, show_y, global.pt_aura, 1);
        
        draw_sprite_ext(spr_cards, inc_card.icon_index, show_x, show_y, 3.5, 3.5, 0, c_white, 1);
        
        draw_set_color(c_yellow);
        draw_text_transformed(show_x, show_y + 200, inc_card.name, 1.2, 1.2, 0);
        draw_set_halign(fa_left);

        // Tooltip for New Card
        if (point_in_rectangle(mx, my, show_x-110, show_y-140, show_x+110, show_y+140)) {
             mgr.tooltip_header = "NEW: " + inc_card.name;
             mgr.tooltip_text = inc_card.description;
        }
    }

    // BUTTONS & TEXT
    draw_set_halign(fa_center); 
    draw_set_color(c_white); draw_text_transformed(960, 50, "HAND FULL! DISCARD ONE", 1.5, 1.5, 0);

    if (mgr.discard_selected_index != -1) {
        var sel_card = mgr.player_hand[mgr.discard_selected_index];
        draw_text(960, 420, "Selected: " + sel_card.name);

        // COORDS RESTORED TO ENSURE CLICKS WORK
        var c_hover = point_in_rectangle(mx, my, 800, 480, 950, 560);
        draw_set_color(c_hover ? c_lime : c_green);
        draw_rectangle(800, 480, 950, 560, false);
        draw_set_color(c_black); draw_text(875, 505, "CONFIRM");
        
        var can_hover = point_in_rectangle(mx, my, 970, 480, 1120, 560);
        draw_set_color(can_hover ? c_red : c_maroon);
        draw_rectangle(970, 480, 1120, 560, false);
        draw_set_color(c_white); draw_text(1045, 505, "CANCEL");
    } else {
        draw_set_color(c_gray); draw_text(960, 505, "Select card to discard below");
    }
    draw_set_halign(fa_left);
    
    // HAND CARDS
    var d_start_x = 960 - ((array_length(mgr.player_hand) - 1) * 110);
    for (var c = 0; c < array_length(mgr.player_hand); c++) {
        var card = mgr.player_hand[c];
        var cx = d_start_x + (c * 220); 
        var is_sel = (mgr.discard_selected_index == c);
        var cy = 850; 
        
        if (point_in_rectangle(mx, my, cx-75, 750, cx+75, 1080)) cy -= 40;        
        if (is_sel) { cy -= 80; draw_set_color(c_red); draw_circle(cx, cy, 90, false); }

        draw_sprite_ext(spr_cards, card.icon_index, cx, cy, 2.0, 2.0, 0, c_white, 1);
        
        if (point_in_rectangle(mx, my, cx-75, 750, cx+75, 1080)) {
             mgr.tooltip_header = "DISCARD " + card.name + "?";
             mgr.tooltip_text = card.description;
        }
    }
}
// TURN START
else if (mgr.state == BATTLE_STATE.TURN_START_DECISION) {
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
// INPUT PHASE
else if (mgr.state == BATTLE_STATE.INPUT_PHASE) {
    
    // 1. MOVES
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
        draw_set_color(c_ltgray); draw_text(btn_x+10, btn_y+50, "PP: " + string(mv.pp) + "/" + string(mv.max_pp));
        
        if (hover) { 
            mgr.tooltip_header = mv.name; 
            var cat = (mv.base_power>0)? get_gen3_category(mv.type) : "STATUS";
            var t_name = (mv.type < array_length(type_names)) ? type_names[mv.type] : "???";
            mgr.tooltip_text = "Type: " + t_name + "\nCat: " + cat + "\nPow: " + string(mv.base_power) + " | Acc: " + string(mv.accuracy); 
        }
    }
    
    // 2. HAND & RESHUFFLE ANIMATION (USING MGR VARIABLES)
    var anim_offset_y = 0;
    
    // Read the timer from Battle Manager
    if (variable_instance_exists(mgr, "reshuffle_anim_active") && mgr.reshuffle_anim_active) {
        var t = mgr.reshuffle_timer;
        if (t < 20) anim_offset_y = lerp(0, 400, t / 20);
        else if (t < 40) anim_offset_y = 400;
        else anim_offset_y = lerp(400, 0, (t - 40) / 20);
    }
    
    var hand_size = array_length(mgr.player_hand);
    var start_x = 1550 - ((hand_size - 1) * 90); 
    
    for (var c = 0; c < hand_size; c++) {
        var card = mgr.player_hand[c];
        var cx = start_x + (c * 180);
        var cy = mgr.hand_visual_y[c] + anim_offset_y; 
        
        var hov = point_in_rectangle(mx, my, cx - 60, 750 + anim_offset_y, cx + 60, 1080 + anim_offset_y);
        
        if (mgr.selected_card == c && anim_offset_y == 0) { 
            cy -= 20 + sin(current_time/150)*5; 
            if (variable_global_exists("part_sys")) part_particles_create(global.part_sys, cx, cy+80, global.pt_aura, 1); 
        }
        
        draw_sprite_ext(spr_cards, card.icon_index, cx, cy, 2.5, 2.5, 0, c_white, 1);
        if (hov && anim_offset_y == 0) { mgr.tooltip_header = card.name; mgr.tooltip_text = card.description; }
    }
    
    // 3. EVENT CARD
    if (mgr.event_card_active != undefined) {
        var ec = mgr.event_card_active; var ex = 970; var ey = 260; 
        var is_sel_ev = (mgr.selected_card == 100);
        var e_hov = point_in_rectangle(mx, my, ex-60, ey-80, ex+60, ey+80);
        
        if (is_sel_ev) ey -= 15 + sin(current_time/150)*5;
        else if (e_hov) ey -= 5;

        if (e_hov || is_sel_ev) {
            draw_set_alpha(0.6); draw_set_color(is_sel_ev ? c_lime : c_yellow); draw_circle(ex, ey, 85, false); draw_set_alpha(1);
        }
        draw_sprite_ext(spr_cards, ec.icon_index, ex, ey, 2.0, 2.0, 0, c_white, 1);
        if (e_hov) { mgr.tooltip_header = ec.name; mgr.tooltip_text = ec.description + "\n[EVENT CARD]"; }
    }
    
    // 4. BUTTONS
    draw_set_color(c_orange); draw_rectangle(50, 780, 250, 840, false); draw_set_color(c_black); draw_text(70, 800, "SWITCH");
    
    if (mgr.mulligan_available) { 
        var h_shuff = point_in_rectangle(mx, my, 860, 20, 1060, 100); 
        draw_set_color(h_shuff ? c_purple : c_dkgray); 
        draw_rectangle(860, 20, 1060, 100, false); 
        draw_set_color(c_white); draw_text(900, 50, "RESHUFFLE"); 
        
        // TRIGGER RESHUFFLE ANIMATION IN BATTLE MANAGER
        if (h_shuff && mouse_check_button_pressed(mb_left) && variable_instance_exists(mgr, "reshuffle_anim_active")) {
             if (!mgr.reshuffle_anim_active) {
                 mgr.reshuffle_anim_active = true;
                 mgr.reshuffle_timer = 0;
             }
        }
    }
    
    if (mgr.selected_move != -1 || mgr.selected_card != -1) {
        draw_set_color(c_lime); draw_rectangle(860, 780, 1060, 840, false); draw_set_color(c_black); draw_set_halign(fa_center); draw_text(960, 800, "GO!"); draw_set_halign(fa_left);
    }
}
// SWITCH/REVIVE
else if (mgr.state == BATTLE_STATE.SWITCH_MENU || mgr.state == BATTLE_STATE.REVIVE_MENU) {
    draw_set_color(c_black); draw_set_alpha(0.9); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    draw_set_color(c_white); draw_text(100, 100, (mgr.state==BATTLE_STATE.SWITCH_MENU)?"SWITCH":"REVIVE");
    for (var i = 0; i < array_length(mgr.player_team); i++) {
        var pm = mgr.player_team[i]; var py = 200 + (i * 120);
        var is_dead = (pm.current_hp <= 0);
        var box_col = (i==mgr.p_active_index) ? c_lime : c_white; if (is_dead) box_col = c_gray;
        if (point_in_rectangle(mx, my, 100, py, 600, py+100)) box_col = c_yellow;
        
        draw_set_color(box_col); draw_rectangle(96, py-4, 604, py+104, false); draw_set_color(c_black); draw_rectangle(100, py, 600, py+100, false);
        draw_set_color((is_dead) ? c_red : c_white); draw_text(120, py+20, pm.nickname + " " + string(ceil(pm.display_hp)) + "/" + string(pm.max_hp));
    }
    draw_set_color(c_red); draw_rectangle(700, 900, 900, 1000, false); draw_set_color(c_white); draw_text(740, 940, "CANCEL");
}

// RENDER TOOLTIP (ADAPTIVE SIZE)
if (mgr.tooltip_text != "") {
    var max_w = 400; var sep = 28;    
    var text_w = string_width_ext(mgr.tooltip_text, sep, max_w);
    var text_h = string_height_ext(mgr.tooltip_text, sep, max_w);
    var head_w = string_width(mgr.tooltip_header);
    
    var box_w = max(text_w, head_w) + 40;
    var box_h = text_h + 80;
    var tx = mx + 20; var ty = my - box_h - 20; 
    
    if (tx + box_w > 1920) tx = mx - box_w - 20; 
    if (ty < 0) ty = my + 20;
    
    draw_set_color(c_black); draw_set_alpha(0.95); draw_roundrect(tx, ty, tx+box_w, ty+box_h, false); draw_set_alpha(1.0);
    draw_set_color(c_white); draw_roundrect(tx, ty, tx+box_w, ty+box_h, true);
    
    draw_set_color(c_yellow); draw_text(tx+20, ty+15, mgr.tooltip_header);
    draw_set_color(c_gray); draw_line(tx+10, ty+50, tx+box_w-10, ty+50);
    draw_set_color(c_white); draw_text_ext(tx+20, ty+60, mgr.tooltip_text, sep, max_w);
}