if (!instance_exists(obj_battle_manager)) exit;
var mgr = obj_battle_manager;

var p_mon = mgr.player_team[mgr.p_active_index];
var e_mon = mgr.enemy_team[mgr.e_active_index];

draw_set_font(fnt_game);
var time_sec = current_time / 1000;

// --- ICON HELPER FUNCTION ---
function get_active_icons(_mon) {
    var list = [];
    // Status Indices: 3=PAR, 4=BRN, 5=PSN, 6=SLP
    if (_mon.status_condition == "PAR") array_push(list, {idx: 3, text: ""});
    if (_mon.status_condition == "BRN") array_push(list, {idx: 4, text: ""});
    if (_mon.status_condition == "PSN") array_push(list, {idx: 5, text: ""});
    if (_mon.status_condition == "SLP") array_push(list, {idx: 6, text: ""});
    
    // Stat Indices: 0=Atk/SpA, 1=Def/SpD, 2=Spe
    if (_mon.stat_stages.atk != 0) array_push(list, {idx: 0, text: (_mon.stat_stages.atk>0?"+":"") + string(_mon.stat_stages.atk)});
    if (_mon.stat_stages.def != 0) array_push(list, {idx: 1, text: (_mon.stat_stages.def>0?"+":"") + string(_mon.stat_stages.def)});
    if (_mon.stat_stages.spa != 0) array_push(list, {idx: 0, text: (_mon.stat_stages.spa>0?"+":"") + string(_mon.stat_stages.spa)});
    if (_mon.stat_stages.spd != 0) array_push(list, {idx: 1, text: (_mon.stat_stages.spd>0?"+":"") + string(_mon.stat_stages.spd)});
    if (_mon.stat_stages.spe != 0) array_push(list, {idx: 2, text: (_mon.stat_stages.spe>0?"+":"") + string(_mon.stat_stages.spe)});
    
    // Temp Card Buffs
    if (_mon.card_buffs.atk > 1) array_push(list, {idx: 0, text: "Tmp"});
    if (_mon.card_buffs.def > 1) array_push(list, {idx: 1, text: "Tmp"});
    if (_mon.card_buffs.spe > 1) array_push(list, {idx: 2, text: "Tmp"});
    
    return list;
}

var p_icons = get_active_icons(p_mon);
var e_icons = get_active_icons(e_mon);

// Cycle Logic (Change every 1.5s)
var p_icon_idx = 0; 
if (array_length(p_icons) > 0) p_icon_idx = floor(time_sec / 1.5) % array_length(p_icons);
var e_icon_idx = 0;
if (array_length(e_icons) > 0) e_icon_idx = floor(time_sec / 1.5) % array_length(e_icons);

var shake_x = random_range(-mgr.screen_shake, mgr.screen_shake);
var shake_y = random_range(-mgr.screen_shake, mgr.screen_shake);

// -------------------------------------------------------------------------
// ENEMY RENDER
// -------------------------------------------------------------------------
var e_draw_x = 1480 + shake_x + mgr.e_offset_x;
var e_draw_y = 1100 + shake_y + mgr.e_offset_y;

var e_has_debuff = e_mon.has_any_debuff();
var e_shader_active = false;
if (e_has_debuff) {
    shader_set(shd_debuff); shader_set_uniform_f(mgr.u_time_uni_debuff, time_sec); e_shader_active = true;
} else if (e_mon.has_any_buff()) {
    shader_set(shd_buff); shader_set_uniform_f(mgr.u_time_uni_buff, time_sec); e_shader_active = true;
}
draw_sprite_ext(spr_pokemon_master_back, e_mon.sprite_frame, e_draw_x, e_draw_y, 2, 2, 0, c_white, 1);
if (e_shader_active) shader_reset();

if (mgr.e_flash_alpha > 0) {
    gpu_set_fog(true, c_white, 0, 0); 
    draw_sprite_ext(spr_pokemon_master_back, e_mon.sprite_frame, e_draw_x, e_draw_y, 2, 2, 0, c_white, mgr.e_flash_alpha);
    gpu_set_fog(false, c_white, 0, 0); 
}

// ENEMY UI & ICONS (Top Left)
draw_set_color(c_dkgray); draw_rectangle(0, 0, 600, 140, false);
draw_set_color(c_white); draw_text(20, 10, e_mon.species_name + " Lv." + string(e_mon.level));
draw_set_color(c_black); draw_rectangle(20, 50, 500, 80, false);
draw_healthbar(20, 50, 500, 80, (e_mon.current_hp / e_mon.max_hp) * 100, c_black, c_red, c_green, 0, true, true);

// Enemy Icons (To the right of the HP box)
if (array_length(e_icons) > 0) {
    var icon_data = e_icons[e_icon_idx];
    draw_sprite_ext(spr_status_icons, icon_data.idx, 620, 70, 2, 2, 0, c_white, 1);
    draw_set_color(c_white); 
    draw_text(660, 70, icon_data.text);
}


// -------------------------------------------------------------------------
// PLAYER RENDER
// -------------------------------------------------------------------------
var p_draw_x = 400 + shake_x + mgr.p_offset_x;
var p_draw_y = 1100 + shake_y + mgr.p_offset_y;

var p_has_debuff = p_mon.has_any_debuff();
var p_shader_active = false;
if (p_has_debuff) {
    shader_set(shd_debuff); shader_set_uniform_f(mgr.u_time_uni_debuff, time_sec); p_shader_active = true;
} else if (p_mon.has_any_buff()) {
    shader_set(shd_buff); shader_set_uniform_f(mgr.u_time_uni_buff, time_sec); p_shader_active = true;
}
draw_sprite_ext(spr_pokemon_master_front, p_mon.sprite_frame, p_draw_x, p_draw_y, 2, 2, 0, c_white, 1);
if (p_shader_active) shader_reset();

if (mgr.p_flash_alpha > 0) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(spr_pokemon_master_front, p_mon.sprite_frame, p_draw_x, p_draw_y, 2, 2, 0, c_white, mgr.p_flash_alpha);
    gpu_set_fog(false, c_white, 0, 0);
}

// PLAYER UI & ICONS (Bottom Right)
draw_set_color(c_dkgray); draw_rectangle(1300, 700, 1920, 850, false);
draw_set_color(c_white);
draw_text(1320, 710, p_mon.species_name + " Lv." + string(p_mon.level));
draw_text(1320, 740, string(p_mon.current_hp) + "/" + string(p_mon.max_hp));
draw_healthbar(1400, 770, 1800, 810, (p_mon.current_hp / p_mon.max_hp)*100, c_black, c_red, c_green, 0, true, true);

// Player Icons (To the left of the HP box)
if (array_length(p_icons) > 0) {
    var icon_data = p_icons[p_icon_idx];
    draw_sprite_ext(spr_status_icons, icon_data.idx, 1250, 770, 2, 2, 0, c_white, 1);
    draw_set_color(c_white); 
    draw_text(1220, 770, icon_data.text);
}


// -------------------------------------------------------------------------
// CARD ANIMATION
// -------------------------------------------------------------------------
if (mgr.card_anim_active) {
    var progress = 1.0 - (mgr.card_anim_timer / 60.0);
    progress = sin(progress * pi / 2);
    var draw_cy = lerp(1080, 540, progress);
    draw_set_color(c_white); draw_rectangle(860, draw_cy - 75, 1060, draw_cy + 75, false);
    draw_set_color(c_black); draw_text(870, draw_cy - 10, mgr.card_anim_data.name);
    draw_text(870, draw_cy + 10, "ACTIVATED!");
}

// -------------------------------------------------------------------------
// BATTLE LOG
// -------------------------------------------------------------------------
draw_set_color(c_black); draw_rectangle(0, 850, 1920, 1080, false);
draw_set_color(c_white); 
draw_set_halign(fa_center);
draw_text_ext(960, 900, mgr.battle_log, 30, 800);
draw_set_halign(fa_left);


// =========================================================================
// STATE MACHINE UI - FULL RESTORE
// =========================================================================

// 1. REVIVE MENU
if (mgr.state == BATTLE_STATE.REVIVE_MENU) {
    draw_set_color(c_black); draw_set_alpha(0.9); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    draw_set_color(c_white); draw_text(100, 100, "Select Fainted Pokémon to Revive:");
    
    for (var i = 0; i < array_length(mgr.player_team); i++) {
        var pm = mgr.player_team[i];
        var py = 200 + (i * 120);
        if (pm.current_hp <= 0) draw_set_color(c_red); // Valid
        else draw_set_color(c_dkgray);
        
        draw_rectangle(100, py, 600, py+100, true);
        draw_text(120, py+20, pm.nickname + " " + string(pm.current_hp) + "/" + string(pm.max_hp));
        
        if (mouse_check_button_pressed(mb_left)) {
            var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
            if (mx > 100 && mx < 600 && my > py && my < py+100) {
                if (pm.current_hp <= 0) {
                    mgr.revive_target_index = i;
                    mgr.state = BATTLE_STATE.RESOLVE_PHASE;
                }
            }
        }
    }
    draw_set_color(c_red); draw_rectangle(700, 900, 900, 1000, false);
    draw_set_color(c_white); draw_text(750, 940, "CANCEL");
    if (mouse_check_button_pressed(mb_left)) {
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        if (mx > 700 && mx < 900 && my > 900 && my < 1000) mgr.state = BATTLE_STATE.INPUT_PHASE;
    }
}

// 2. TURN START (Draw Decision)
else if (mgr.state == BATTLE_STATE.TURN_START_DECISION) {
    draw_set_color(c_black); draw_set_alpha(0.7); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    draw_set_color(c_white); draw_set_halign(fa_center); draw_text(960, 400, "Draw a Card?");
    
    // YES
    draw_set_color(c_lime); draw_rectangle(760, 500, 910, 580, false);
    draw_set_color(c_black); draw_text(800, 520, "YES");
    if (mouse_check_button_pressed(mb_left)) {
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        if (mx > 760 && mx < 910 && my > 500 && my < 580) {
            if (array_length(mgr.player_hand) >= mgr.max_hand_size) {
                mgr.state = BATTLE_STATE.DISCARD_CHOICE;
                mgr.battle_log = "Hand Full! Discard one card to draw.";
            } else {
                if (array_length(mgr.player_deck) > 0) {
                     array_push(mgr.player_hand, get_card_data(mgr.player_deck[0]));
                     array_delete(mgr.player_deck, 0, 1);
                } else {
                     array_push(mgr.player_hand, get_card_data("potion_hyper"));
                }
                mgr.state = BATTLE_STATE.INPUT_PHASE;
            }
        }
    }
    // NO
    draw_set_color(c_red); draw_rectangle(1010, 500, 1160, 580, false);
    draw_set_color(c_black); draw_text(1050, 520, "NO");
    if (mouse_check_button_pressed(mb_left)) {
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        if (mx > 1010 && mx < 1160 && my > 500 && my < 580) mgr.state = BATTLE_STATE.INPUT_PHASE;
    }
    draw_set_halign(fa_left);
}

// 3. DISCARD CHOICE (Hand Full)
else if (mgr.state == BATTLE_STATE.DISCARD_CHOICE) {
    draw_set_color(c_black); draw_set_alpha(0.7); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    draw_set_color(c_white); draw_set_halign(fa_center); draw_text(960, 200, "Select a card to DISCARD:");
    
    for (var c = 0; c < array_length(mgr.player_hand); c++) {
        var card = mgr.player_hand[c];
        var cx = 600 + (c * 150); var cy = 400; 
        draw_set_color(c_gray); draw_rectangle(cx, cy, cx+140, cy+200, false);
        draw_set_color(c_black); draw_text(cx+10, cy+10, card.name);
        if (mouse_check_button_pressed(mb_left)) {
            var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
            if (mx > cx && mx < cx+140 && my > cy && my < cy+200) {
                array_delete(mgr.player_hand, c, 1);
                // Draw new card
                if (array_length(mgr.player_deck) > 0) {
                     array_push(mgr.player_hand, get_card_data(mgr.player_deck[0]));
                     array_delete(mgr.player_deck, 0, 1);
                } else {
                     array_push(mgr.player_hand, get_card_data("potion_hyper"));
                }
                mgr.state = BATTLE_STATE.INPUT_PHASE;
            }
        }
    }
    draw_set_halign(fa_left);
}

// 4. SWITCH MENU
else if (mgr.state == BATTLE_STATE.SWITCH_MENU) {
    draw_set_color(c_black); draw_set_alpha(0.9); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    draw_set_color(c_white); draw_text(100, 100, "Select Pokémon to Switch:");
    
    for (var i = 0; i < array_length(mgr.player_team); i++) {
        var pm = mgr.player_team[i];
        var py = 200 + (i * 120);
        if (i == mgr.p_active_index) draw_set_color(c_lime);
        else if (pm.current_hp <= 0) draw_set_color(c_red);
        else draw_set_color(c_white);
        draw_rectangle(100, py, 600, py+100, true);
        draw_text(120, py+20, pm.nickname + " " + string(pm.current_hp) + "/" + string(pm.max_hp));
        if (mouse_check_button_pressed(mb_left)) {
            var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
            if (mx > 100 && mx < 600 && my > py && my < py+100) {
                if (pm.current_hp > 0 && i != mgr.p_active_index) {
                    mgr.selected_switch_target = i;
                    mgr.state = BATTLE_STATE.RESOLVE_PHASE; 
                }
            }
        }
    }
    draw_set_color(c_red); draw_rectangle(700, 900, 900, 1000, false);
    draw_set_color(c_white); draw_text(750, 940, "CANCEL");
    if (mouse_check_button_pressed(mb_left)) {
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        if (mx > 700 && mx < 900 && my > 900 && my < 1000) mgr.state = BATTLE_STATE.INPUT_PHASE;
    }
}

// 5. INPUT PHASE
else if (mgr.state == BATTLE_STATE.INPUT_PHASE) {
    
    // Switch Button
    draw_set_color(c_orange); draw_rectangle(50, 780, 250, 840, false);
    draw_set_color(c_black); draw_text(70, 800, "SWITCH PKMN");
    if (mouse_check_button_pressed(mb_left)) {
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        if (mx > 50 && mx < 250 && my > 780 && my < 840) mgr.state = BATTLE_STATE.SWITCH_MENU;
    }
    
    // Reshuffle
    if (mgr.mulligan_available) {
        draw_set_color(c_purple); draw_rectangle(860, 20, 1060, 100, false);
        draw_set_color(c_white); draw_text(900, 50, "RESHUFFLE");
        if (mouse_check_button_pressed(mb_left)) {
            var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
            if (mx > 860 && mx < 1060 && my > 20 && my < 100) {
                var count = array_length(mgr.player_hand);
                mgr.player_hand = [];
                repeat(count) {
                    if (array_length(mgr.player_deck) > 0) {
                         array_push(mgr.player_hand, get_card_data(mgr.player_deck[0]));
                         array_delete(mgr.player_deck, 0, 1);
                    } else {
                         array_push(mgr.player_hand, get_card_data("potion_hyper"));
                    }
                }
                mgr.mulligan_available = false;
                mgr.battle_log = "Hand reshuffled!";
            }
        }
    }
    
    // Moves
    for (var i = 0; i < array_length(p_mon.moves); i++) {
        var row = floor(i / 2);
        var col = i % 2;
        var mx = 50 + (col * 320);
        var my = 870 + (row * 100);
        if (mgr.selected_move == i) draw_set_color(c_yellow); else draw_set_color(c_gray);
        draw_rectangle(mx, my, mx+300, my+90, false);
        draw_set_color(c_black);
        draw_text(mx+10, my+10, p_mon.moves[i].name);
        draw_text(mx+10, my+40, "PP: " + string(p_mon.moves[i].pp));
        if (mouse_check_button_pressed(mb_left)) {
            var gui_mx = device_mouse_x_to_gui(0); var gui_my = device_mouse_y_to_gui(0);
            if (gui_mx > mx && gui_mx < mx+300 && gui_my > my && gui_my < my+90) {
                if (mgr.selected_move == i) mgr.selected_move = -1;
                else mgr.selected_move = i;
            }
        }
    }
    
    // Cards
    for (var c = 0; c < array_length(mgr.player_hand); c++) {
        var row = floor(c / 2);
        var col = c % 2;
        var cx = 1350 + (col * 270);
        var cy = 870 + (row * 100);
        var card = mgr.player_hand[c];
        if (mgr.selected_card == c) draw_set_color(c_aqua); else draw_set_color(c_dkgray);
        draw_rectangle(cx, cy, cx+250, cy+90, false);
        draw_set_color(c_white);
        draw_text(cx+10, cy+5, card.name);
        draw_text_ext_transformed(cx+10, cy+30, card.description, 15, 400, 0.6, 0.6, 0);
        if (mouse_check_button_pressed(mb_left)) {
            var gui_cx = device_mouse_x_to_gui(0); var gui_cy = device_mouse_y_to_gui(0);
            if (gui_cx > cx && gui_cx < cx+250 && gui_cy > cy && gui_cy < cy+90) {
                if (card.id == "revive") {
                    mgr.selected_card = c;
                    mgr.state = BATTLE_STATE.REVIVE_MENU;
                } else {
                    if (mgr.selected_card == c) mgr.selected_card = -1;
                    else mgr.selected_card = c;
                }
            }
        }
    }
    
    // GO
    if (mgr.selected_move != -1 || mgr.selected_card != -1) {
        draw_set_color(c_lime);
        draw_rectangle(860, 780, 1060, 840, false);
        draw_set_color(c_black);
        draw_set_halign(fa_center);
        draw_text(960, 800, "GO!");
        draw_set_halign(fa_left);
        if (mouse_check_button_pressed(mb_left)) {
            var gui_bx = device_mouse_x_to_gui(0); var gui_by = device_mouse_y_to_gui(0);
             if (gui_bx > 860 && gui_bx < 1060 && gui_by > 780 && gui_by < 840) {
                mgr.state = BATTLE_STATE.RESOLVE_PHASE;
            }
        }
    }
}