// --------------------------------------------------------
// UI MANAGER - DRAW GUI
// --------------------------------------------------------
if (!instance_exists(obj_battle_manager)) exit;
var mgr = obj_battle_manager;

// Safety check for indices
if (mgr.p_active_index >= array_length(mgr.player_team)) exit;
if (mgr.e_active_index >= array_length(mgr.enemy_team)) exit;

var p_mon = mgr.player_team[mgr.p_active_index];
var e_mon = mgr.enemy_team[mgr.e_active_index];

draw_set_font(fnt_game);
var time_sec = current_time / 1000;

// --- RESET TOOLTIP ---
mgr.tooltip_text = "";
mgr.tooltip_header = "";

// --- BACKGROUND DIM (Action Phase) ---
if (mgr.bg_dim_alpha > 0) {
    draw_set_color(c_black);
    draw_set_alpha(mgr.bg_dim_alpha);
    draw_rectangle(0, 0, 1920, 1080, false);
    draw_set_alpha(1.0);
}

// --- SHAKE CALCULATIONS ---
var shake_x = random_range(-mgr.screen_shake, mgr.screen_shake);
var shake_y = random_range(-mgr.screen_shake, mgr.screen_shake);

// =========================================================================
// 1. DRAW POKEMON (Behind HUD)
// =========================================================================

// ENEMY
var e_draw_x = 1480 + shake_x + mgr.e_offset_x;
var e_draw_y = 1100 + shake_y + mgr.e_offset_y;
var e_has_debuff = e_mon.has_any_debuff();
var e_shader_on = false;

if (e_has_debuff) {
    shader_set(shd_red_throb); 
    shader_set_uniform_f(shader_get_uniform(shd_red_throb, "u_time"), time_sec);
    e_shader_on = true;
} else if (e_mon.has_any_buff()) {
    shader_set(shd_buff); 
    shader_set_uniform_f(mgr.u_time_uni_buff, time_sec);
    e_shader_on = true;
}
draw_sprite_ext(spr_pokemon_master_back, e_mon.sprite_frame, e_draw_x, e_draw_y, 2, 2, 0, c_white, 1);
if (e_shader_on) shader_reset();

if (mgr.e_flash_alpha > 0) {
    gpu_set_fog(true, c_white, 0, 0); 
    draw_sprite_ext(spr_pokemon_master_back, e_mon.sprite_frame, e_draw_x, e_draw_y, 2, 2, 0, c_white, mgr.e_flash_alpha);
    gpu_set_fog(false, c_white, 0, 0); 
}

// PLAYER
var p_draw_x = 400 + shake_x + mgr.p_offset_x;
var p_draw_y = 1100 + shake_y + mgr.p_offset_y;
var p_has_debuff = p_mon.has_any_debuff();
var p_shader_on = false;

if (p_has_debuff) {
    shader_set(shd_red_throb);
    shader_set_uniform_f(shader_get_uniform(shd_red_throb, "u_time"), time_sec);
    p_shader_on = true;
} else if (p_mon.has_any_buff()) {
    shader_set(shd_buff); 
    shader_set_uniform_f(mgr.u_time_uni_buff, time_sec);
    p_shader_on = true;
}
draw_sprite_ext(spr_pokemon_master_front, p_mon.sprite_frame, p_draw_x, p_draw_y, 2, 2, 0, c_white, 1);
if (p_shader_on) shader_reset();

if (mgr.p_flash_alpha > 0) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(spr_pokemon_master_front, p_mon.sprite_frame, p_draw_x, p_draw_y, 2, 2, 0, c_white, mgr.p_flash_alpha);
    gpu_set_fog(false, c_white, 0, 0);
}

// =========================================================================
// 2. HUD & STATUS (On Top of Pokemon)
// =========================================================================

// --- HELPER FOR STATUS ICONS ---
function get_active_icons_v2(_mon) {
    var list = [];
    if (_mon.status_condition == "PAR") array_push(list, {idx: 3, text: ""});
    else if (_mon.status_condition == "BRN") array_push(list, {idx: 4, text: ""});
    else if (_mon.status_condition == "PSN") array_push(list, {idx: 5, text: ""});
    else if (_mon.status_condition == "SLP") array_push(list, {idx: 6, text: ""});
    
    var s = _mon.stat_stages;
    if (s.atk > 0) array_push(list, {idx: 0, text: "+" + string(s.atk)});
    if (s.atk < 0) array_push(list, {idx: 9, text: string(s.atk)});
    if (s.def > 0) array_push(list, {idx: 1, text: "+" + string(s.def)});
    if (s.def < 0) array_push(list, {idx: 10, text: string(s.def)});
    if (s.spa > 0) array_push(list, {idx: 7, text: "+" + string(s.spa)});
    if (s.spa < 0) array_push(list, {idx: 11, text: string(s.spa)});
    if (s.spd > 0) array_push(list, {idx: 8, text: "+" + string(s.spd)});
    if (s.spd < 0) array_push(list, {idx: 12, text: string(s.spd)});
    if (s.spe > 0) array_push(list, {idx: 2, text: "+" + string(s.spe)});
    if (s.spe < 0) array_push(list, {idx: 2, text: string(s.spe)});
    return list;
}

var p_icons = get_active_icons_v2(p_mon);
var e_icons = get_active_icons_v2(e_mon);
var p_icon_idx = (array_length(p_icons) > 0) ? floor(time_sec / 1.5) % array_length(p_icons) : 0;
var e_icon_idx = (array_length(e_icons) > 0) ? floor(time_sec / 1.5) % array_length(e_icons) : 0;

// --- ENEMY HUD ---
// Border
draw_set_color(c_white); draw_rectangle(0, 0, 604, 144, false);
draw_set_color(c_black); draw_rectangle(4, 4, 600, 140, false);

// Text
draw_set_color(c_white); draw_text(20, 10, e_mon.species_name + " Lv." + string(e_mon.level));

// Health Bar
draw_set_color(c_dkgray); draw_rectangle(20, 50, 500, 80, false);
var e_hp_pct = (e_mon.current_hp / e_mon.max_hp) * 100;
draw_healthbar(20, 50, 500, 80, e_hp_pct, c_dkgray, c_red, c_lime, 0, true, true);

// Status Icon
if (array_length(e_icons) > 0) {
    var idata = e_icons[e_icon_idx];
    draw_sprite_ext(spr_status_icons, idata.idx, 560, 90, 2, 2, 0, c_white, 1);
    draw_set_halign(fa_center);
    draw_text(560, 110, idata.text);
    draw_set_halign(fa_left);
}

// --- PLAYER HUD ---
// Border
draw_set_color(c_white); draw_rectangle(1296, 696, 1920, 854, false);
draw_set_color(c_black); draw_rectangle(1300, 700, 1920, 850, false);

// Text
draw_set_color(c_white);
draw_text(1320, 710, p_mon.species_name + " Lv." + string(p_mon.level));
draw_set_color(c_ltgray);
draw_text(1320, 740, string(p_mon.current_hp) + " / " + string(p_mon.max_hp));

// Health Bar
var p_hp_pct = (p_mon.current_hp / p_mon.max_hp) * 100;
draw_healthbar(1400, 770, 1800, 810, p_hp_pct, c_dkgray, c_red, c_lime, 0, true, true);

// Status Icon
if (array_length(p_icons) > 0) {
    var idata = p_icons[p_icon_idx];
    draw_sprite_ext(spr_status_icons, idata.idx, 1250, 770, 2, 2, 0, c_white, 1);
    draw_text(1220, 770, idata.text);
}


// =========================================================================
// 3. UI, MENUS, & LOGIC
// =========================================================================

// --- CARD ACTIVATION ANIMATION ---
if (mgr.card_anim_active) {
    var progress = 1.0 - (mgr.card_anim_timer / 60.0);
    progress = sin(progress * pi / 2);
    var draw_cy = lerp(1080, 540, progress);
    
    // Glowing Card effect
    draw_set_alpha(0.8);
    draw_set_color(c_aqua); draw_rectangle(850, draw_cy - 85, 1070, draw_cy + 85, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white); draw_rectangle(860, draw_cy - 75, 1060, draw_cy + 75, false);
    
    draw_set_color(c_black); 
    draw_set_halign(fa_center);
    draw_text(960, draw_cy - 10, mgr.card_anim_data.name);
    draw_text(960, draw_cy + 20, "ACTIVATED!");
    draw_set_halign(fa_left);
}

// --- BATTLE LOG (Typewriter) ---
draw_set_color(c_white); draw_rectangle(0, 846, 1920, 850, false); // Separator Line
draw_set_color(c_black); draw_rectangle(0, 850, 1920, 1080, false);

draw_set_color(c_white); 
draw_set_halign(fa_center);
// Using 30 char limit approx via sep/w logic or string manipulation? 
// draw_text_ext automatically wraps. We set width to something that allows ~30 chars with big font.
draw_text_ext(960, 900, mgr.battle_log_display, 40, 900);
draw_set_halign(fa_left);

// --- REVIVE MENU ---
if (mgr.state == BATTLE_STATE.REVIVE_MENU) {
    draw_set_color(c_black); draw_set_alpha(0.9); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    draw_set_color(c_white); draw_text(100, 100, "Select Fainted Pokémon to Revive:");
    
    for (var i = 0; i < array_length(mgr.player_team); i++) {
        var pm = mgr.player_team[i];
        var py = 200 + (i * 120);
        var col_border = (pm.current_hp <= 0) ? c_red : c_gray;
        
        draw_set_color(col_border); draw_rectangle(96, py-4, 604, py+104, false); // Border
        draw_set_color(c_black); draw_rectangle(100, py, 600, py+100, false);     // Inner
        
        draw_set_color(c_white);
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
    // Cancel Button
    draw_set_color(c_red); draw_rectangle(700, 900, 900, 1000, false);
    draw_set_color(c_white); draw_set_halign(fa_center); draw_text(800, 940, "CANCEL"); draw_set_halign(fa_left);
    if (mouse_check_button_pressed(mb_left)) {
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        if (mx > 700 && mx < 900 && my > 900 && my < 1000) mgr.state = BATTLE_STATE.INPUT_PHASE;
    }
}

// --- TURN START DECISION (Infinite Deck handled in Step, this is UI) ---
else if (mgr.state == BATTLE_STATE.TURN_START_DECISION) {
    draw_set_color(c_black); draw_set_alpha(0.7); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_color(c_white); draw_text(960, 400, "Draw a Card?");
    
    var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
    
    // YES
    var h_yes = point_in_rectangle(mx, my, 760, 500, 910, 580);
    draw_set_color(h_yes ? c_white : c_lime); draw_rectangle(756, 496, 914, 584, false); // Border
    draw_set_color(c_black); draw_rectangle(760, 500, 910, 580, false);
    draw_set_color(c_white); draw_text(835, 520, "YES");
    
    if (mouse_check_button_pressed(mb_left) && h_yes) {
         if (array_length(mgr.player_hand) >= mgr.max_hand_size) {
            mgr.state = BATTLE_STATE.DISCARD_CHOICE;
            mgr.battle_log = "Hand Full!";
            mgr.battle_log_display = ""; // Reset typewriter
        } else {
            // Infinite Deck Check
            if (array_length(mgr.player_deck) == 0) {
                var master = obj_game_data.master_deck_list;
                array_copy(mgr.player_deck, 0, master, 0, array_length(master));
                // Shuffle
                var n = array_length(mgr.player_deck);
                for (var i = n - 1; i > 0; i--) {
                    var j = irandom(i);
                    var temp = mgr.player_deck[i];
                    mgr.player_deck[i] = mgr.player_deck[j];
                    mgr.player_deck[j] = temp;
                }
                mgr.battle_log = "Deck Shuffled!";
                mgr.battle_log_display = "";
            }
            
            // Draw
            var spawn_heal = (random(100) < 25);
            if (spawn_heal) {
                 var h = choose("potion_hyper", "revive");
                 array_push(mgr.player_hand, get_card_data(h));
                 mgr.battle_log = "Found " + h + "!";
            } else {
                 array_push(mgr.player_hand, get_card_data(mgr.player_deck[0]));
                 array_delete(mgr.player_deck, 0, 1);
                 mgr.battle_log = "Drew Card!";
            }
            mgr.battle_log_display = "";
            mgr.state = BATTLE_STATE.INPUT_PHASE;
        }
    }
    
    // NO
    var h_no = point_in_rectangle(mx, my, 1010, 500, 1160, 580);
    draw_set_color(h_no ? c_white : c_red); draw_rectangle(1006, 496, 1164, 584, false);
    draw_set_color(c_black); draw_rectangle(1010, 500, 1160, 580, false);
    draw_set_color(c_white); draw_text(1085, 520, "NO");
    
    if (mouse_check_button_pressed(mb_left) && h_no) mgr.state = BATTLE_STATE.INPUT_PHASE;
    
    draw_set_halign(fa_left);
}

// --- DISCARD CHOICE ---
else if (mgr.state == BATTLE_STATE.DISCARD_CHOICE) {
    draw_set_color(c_black); draw_set_alpha(0.7); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_color(c_white); draw_text(960, 200, "Select a card to DISCARD:");
    
    for (var c = 0; c < array_length(mgr.player_hand); c++) {
        var card = mgr.player_hand[c];
        var cx = 600 + (c * 150); var cy = 400; 
        
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        var hover = point_in_rectangle(mx, my, cx, cy, cx+140, cy+200);
        var scale = hover ? 4 : 0; // border size expand
        
        draw_set_color(c_white); draw_rectangle(cx-scale, cy-scale, cx+140+scale, cy+200+scale, false);
        draw_set_color(c_gray); draw_rectangle(cx, cy, cx+140, cy+200, false);
        draw_set_color(c_black); draw_text(cx+10, cy+10, card.name);
        
        if (mouse_check_button_pressed(mb_left) && hover) {
            array_delete(mgr.player_hand, c, 1);
            // Draw new card (with infinite deck check)
             if (array_length(mgr.player_deck) == 0) {
                var master = obj_game_data.master_deck_list;
                array_copy(mgr.player_deck, 0, master, 0, array_length(master));
                // Shuffle ... (same as above)
             }
             
             if (array_length(mgr.player_deck) > 0) {
                 array_push(mgr.player_hand, get_card_data(mgr.player_deck[0]));
                 array_delete(mgr.player_deck, 0, 1);
             } else {
                 array_push(mgr.player_hand, get_card_data("potion_hyper")); // Fallback
             }
            mgr.state = BATTLE_STATE.INPUT_PHASE;
        }
    }
    draw_set_halign(fa_left);
}

// --- SWITCH MENU ---
else if (mgr.state == BATTLE_STATE.SWITCH_MENU) {
    draw_set_color(c_black); draw_set_alpha(0.9); draw_rectangle(0,0,1920,1080,false); draw_set_alpha(1);
    draw_set_color(c_white); draw_text(100, 100, "Select Pokémon to Switch:");
    
    for (var i = 0; i < array_length(mgr.player_team); i++) {
        var pm = mgr.player_team[i];
        var py = 200 + (i * 120);
        
        var border_col = c_white;
        if (i == mgr.p_active_index) border_col = c_lime;
        else if (pm.current_hp <= 0) border_col = c_red;
        
        draw_set_color(border_col); draw_rectangle(96, py-4, 604, py+104, false);
        draw_set_color(c_black); draw_rectangle(100, py, 600, py+100, false);
        
        draw_set_color(c_white);
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
    // Cancel
    draw_set_color(c_red); draw_rectangle(700, 900, 900, 1000, false);
    draw_set_color(c_white); draw_set_halign(fa_center); draw_text(800, 940, "CANCEL"); draw_set_halign(fa_left);
    if (mouse_check_button_pressed(mb_left)) {
        var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
        if (mx > 700 && mx < 900 && my > 900 && my < 1000) mgr.state = BATTLE_STATE.INPUT_PHASE;
    }
}

// --- INPUT PHASE (Moves, Cards, Go) ---
else if (mgr.state == BATTLE_STATE.INPUT_PHASE) {
    var mx = device_mouse_x_to_gui(0); 
    var my = device_mouse_y_to_gui(0);
    
    // Switch Button
    draw_set_color(c_white); draw_rectangle(46, 776, 254, 844, false);
    draw_set_color(c_orange); draw_rectangle(50, 780, 250, 840, false);
    draw_set_color(c_black); draw_text(70, 800, "SWITCH PKMN");
    if (mouse_check_button_pressed(mb_left)) {
        if (mx > 50 && mx < 250 && my > 780 && my < 840) mgr.state = BATTLE_STATE.SWITCH_MENU;
    }
    
    // Reshuffle
    if (mgr.mulligan_available) {
        draw_set_color(c_white); draw_rectangle(856, 16, 1064, 104, false);
        draw_set_color(c_purple); draw_rectangle(860, 20, 1060, 100, false);
        draw_set_color(c_white); draw_set_halign(fa_center); draw_text(960, 50, "RESHUFFLE"); draw_set_halign(fa_left);
        if (mouse_check_button_pressed(mb_left)) {
            if (mx > 860 && mx < 1060 && my > 20 && my < 100) {
                // ... (Reshuffle logic same as before) ...
                var count = array_length(mgr.player_hand);
                mgr.player_hand = [];
                repeat(count) {
                    if (array_length(mgr.player_deck) == 0) {
                        // Fill & Shuffle Logic again
                        var master = obj_game_data.master_deck_list;
                        array_copy(mgr.player_deck, 0, master, 0, array_length(master));
                        // Shuffle loop...
                    }
                    if (array_length(mgr.player_deck)>0) {
                         array_push(mgr.player_hand, get_card_data(mgr.player_deck[0]));
                         array_delete(mgr.player_deck, 0, 1);
                    } else array_push(mgr.player_hand, get_card_data("potion_hyper"));
                }
                mgr.mulligan_available = false;
                mgr.battle_log = "Hand reshuffled!";
                mgr.battle_log_display = "";
            }
        }
    }
    
    // MOVES
    // ... inside INPUT PHASE loop, inside MOVES for loop ...

    // MOVES
    for (var i = 0; i < array_length(p_mon.moves); i++) {
        var row = floor(i / 2); var col = i % 2;
        var btn_x = 50 + (col * 320); var btn_y = 870 + (row * 100);
        var mv = p_mon.moves[i];
        
        var hover = point_in_rectangle(mx, my, btn_x, btn_y, btn_x+300, btn_y+90);
        if (hover) {
            mgr.tooltip_header = mv.name;
            
            // Resolve Type Name
            var type_str = "NORMAL";
            switch(mv.type) {
                case ELEMENT.FIRE: type_str="FIRE"; break;
                case ELEMENT.WATER: type_str="WATER"; break;
                case ELEMENT.GRASS: type_str="GRASS"; break;
                case ELEMENT.ELECTRIC: type_str="ELEC"; break;
                case ELEMENT.ICE: type_str="ICE"; break;
                case ELEMENT.FIGHTING: type_str="FIGHT"; break;
                case ELEMENT.POISON: type_str="POISON"; break;
                case ELEMENT.GROUND: type_str="GROUND"; break;
                case ELEMENT.FLYING: type_str="FLYING"; break;
                case ELEMENT.PSYCHIC: type_str="PSYCHIC"; break;
                case ELEMENT.BUG: type_str="BUG"; break;
                case ELEMENT.ROCK: type_str="ROCK"; break;
                case ELEMENT.GHOST: type_str="GHOST"; break;
                case ELEMENT.DRAGON: type_str="DRAGON"; break;
                case ELEMENT.STEEL: type_str="STEEL"; break;
                case ELEMENT.DARK: type_str="DARK"; break;
            }
            
            // Resolve Category
            var cat_str = "STATUS";
            if (mv.base_power > 0) {
                cat_str = get_gen3_category(mv.type); // Function from mechanics script
            }
            
            mgr.tooltip_text = "Type: " + type_str + " | " + cat_str + 
                               "\nPwr: " + string(mv.base_power) + " | Acc: " + string(mv.accuracy) + 
                               "\nPP: " + string(mv.pp);
        }
        
        var border = (mgr.selected_move == i) ? c_yellow : c_white;
        draw_set_color(border); draw_rectangle(btn_x-4, btn_y-4, btn_x+304, btn_y+94, false);
        draw_set_color(c_dkgray); draw_rectangle(btn_x, btn_y, btn_x+300, btn_y+90, false);
        
        draw_set_color(c_white);
        draw_text(btn_x+10, btn_y+10, mv.name);
        draw_text(btn_x+10, btn_y+40, "PP: " + string(mv.pp));
        
        if (mouse_check_button_pressed(mb_left) && hover) {
            mgr.selected_move = (mgr.selected_move == i) ? -1 : i;
        }
    }
    
    // CARDS
    // =========================================================================
    // UI: CARD HAND (Sprite Based, Single Row)
    // =========================================================================
    
    // 1. EVENT CARD (Top Center)
    if (mgr.event_card_active != undefined) {
        var ec = mgr.event_card_active;
        var ex = 970; var ey = 260;
        
        var emx = device_mouse_x_to_gui(0); var emy = device_mouse_y_to_gui(0);
        var e_hover = point_in_rectangle(emx, emy, ex-60, ey-80, ex+60, ey+80);
        
        var e_scale = e_hover ? 1.2 : 1.0;
        
        // Draw Glow
        draw_set_color(c_yellow); draw_set_alpha(0.5);
        draw_circle(ex, ey, 70 * e_scale, false);
        draw_set_alpha(1);
        
        // Draw Card Sprite
        // Assuming spr_cards origin is Center
        draw_sprite_ext(spr_cards, ec.icon_index, ex, ey, 2*e_scale, 2*e_scale, 0, c_white, 1);
        
        if (e_hover) {
            mgr.tooltip_header = ec.name + " (EVENT)";
            mgr.tooltip_text = ec.description + "\n(Vanishes end of turn!)";
            
            if (mouse_check_button_pressed(mb_left) && mgr.state == BATTLE_STATE.INPUT_PHASE) {
                mgr.selected_card = 100; // Special ID for Event Card
            }
        }
        
        // Selection Indicator
        if (mgr.selected_card == 100) {
            draw_set_color(c_white); draw_circle(ex, ey, 80, true);
        }
    }
    
    // 2. PLAYER HAND (Bottom Row)
    var hand_size = array_length(mgr.player_hand);
    if (hand_size > 0) {
        var card_w = 140; // Approx sprite width * scale
        var spacing = 180;
        var total_w = (hand_size - 1) * spacing;
        var start_x = 1550 - (total_w / 2);
        
        for (var c = 0; c < hand_size; c++) {
            var card = mgr.player_hand[c];
            
            // X Position
            var cx = start_x + (c * spacing);
            
            // Hover Logic
            var mx = device_mouse_x_to_gui(0); var my = device_mouse_y_to_gui(0);
            // Hitbox relative to base position
            var hover = point_in_rectangle(mx, my, cx - 60, 750, cx + 60, 1080);
            
            // Y Position Animation
            // Normal: 1080 (Bottom of screen, half hidden)
            // Hover: 950 (Popped up)
            var target_y = hover ? 900 : 1140; 
            if (mgr.selected_card == c) target_y = 880; // Selected is highest
            
            // Draw
            // Dim if another card is hovered and this one isn't
            var col = c_white;
            // (Optional: loop to check if ANY card is hovered to dim others)
            
            // Card Sprite
            draw_sprite_ext(spr_cards, card.icon_index, cx, target_y, 2.5, 2.5, 0, col, 1);
            
            // Rarity Star/Icon?
            if (card.rarity == RARITY.RARE) draw_text(cx-50, target_y-200, "R");
            if (card.rarity == RARITY.EPIC) draw_text(cx-50, target_y-200, "SR");
            if (card.rarity == RARITY.LEGENDARY) draw_text(cx-50, target_y-200, "UR");
            
            if (hover) {
                mgr.tooltip_header = card.name;
                mgr.tooltip_text = card.description;
                if (card.type == CARD_TYPE.TRAP) mgr.tooltip_text += "\n[TRAP - Face Down]";
                if (card.type == CARD_TYPE.MAGIC) mgr.tooltip_text += "\n[MAGIC]";
                
                if (mouse_check_button_pressed(mb_left) && mgr.state == BATTLE_STATE.INPUT_PHASE) {
                    if (card.id == "revive" || card.id == "revive_max") {
                        mgr.selected_card = c;
                        mgr.state = BATTLE_STATE.REVIVE_MENU;
                    } else {
                        mgr.selected_card = (mgr.selected_card == c) ? -1 : c;
                    }
                }
            }
            
            // Selected Indicator
            if (mgr.selected_card == c) {
                draw_set_color(c_aqua); draw_set_alpha(0.5);
                draw_circle(cx, target_y, 80, false);
                draw_set_alpha(1);
            }
        }
    }
    
    // 3. TRAP INDICATOR (On Pokemon HUD)
    if (p_mon.active_trap != undefined) {
        // Draw Face Down Card near Player HUD
        draw_sprite_ext(spr_cards, 59, 1250, 700, 1.5, 1.5, 0, c_white, 1); // 59 = Generic Back of Card frame
        draw_text(1250, 650, "TRAP SET");
    }
    
    // GO BUTTON
    if (mgr.selected_move != -1 || mgr.selected_card != -1) {
        draw_set_color(c_white); draw_rectangle(856, 776, 1064, 844, false);
        draw_set_color(c_lime); draw_rectangle(860, 780, 1060, 840, false);
        draw_set_color(c_black); draw_set_halign(fa_center); draw_text(960, 800, "GO!"); draw_set_halign(fa_left);
        
        if (mouse_check_button_pressed(mb_left)) {
            if (mx > 860 && mx < 1060 && my > 780 && my < 840) mgr.state = BATTLE_STATE.RESOLVE_PHASE;
        }
    }
}

// =========================================================================
// 4. TOOLTIPS (Always Drawn Last on Top)
// =========================================================================
if (mgr.tooltip_text != "") {
    var mx = device_mouse_x_to_gui(0); 
    var my = device_mouse_y_to_gui(0);
    
    var tw = string_width(mgr.tooltip_text) + 20;
    var th = string_height(mgr.tooltip_text) + 40;
    var tx = mx + 20; 
    var ty = my - th - 20;
    
    // Boundary checks
    if (tx + tw > 1920) tx = mx - tw - 20;
    if (ty < 0) ty = my + 20;
    
    draw_set_color(c_dkgray); draw_set_alpha(0.9);
    draw_roundrect(tx, ty, tx+tw, ty+th, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white); draw_roundrect(tx, ty, tx+tw, ty+th, true);
    
    draw_set_color(c_yellow);
    draw_text(tx+10, ty+5, mgr.tooltip_header);
    draw_set_color(c_white);
    draw_text(tx+10, ty+35, mgr.tooltip_text);
}