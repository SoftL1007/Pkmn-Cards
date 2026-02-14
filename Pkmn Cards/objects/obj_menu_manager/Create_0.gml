/// @desc Menu State Machine & Visuals
display_set_gui_size(1920, 1080);

enum MENU_STATE { 
    MAIN, 
    TEAM_BUILDER, 
    MODE_SELECT, 
    ONLINE_LOBBY, // New State
    OPTIONS 
}

state = MENU_STATE.MAIN;

// UI State
selected_slot = -1; 
scroll_offset = 0;
current_tab = 0;    
items_per_page = 12;

// Visuals
menu_anim_y = 0;        
target_anim_y = 0;      
hover_scale = 1.0;
menu_font = fnt_game; 

// Inputs for IP Address (for Join Game)
join_ip_string = "127.0.0.1";
is_typing_ip = false;

// --- BUTTON HELPER ---
function draw_button_juicy(_x, _y, _w, _h, _text, _mx, _my, _clicked) {
    var hover = point_in_rectangle(_mx, _my, _x, _y, _x+_w, _y+_h);
    
    // Juice
    var scale = hover ? 1.05 : 1.0;
    var col = hover ? c_lime : c_gray;
    if (_clicked && hover) col = c_white; 
    
    var cx = _x + _w/2;
    var cy = _y + _h/2;
    
    // Shadow
    draw_set_color(c_black); draw_set_alpha(0.5);
    draw_rectangle(cx - (_w*scale)/2 + 4, cy - (_h*scale)/2 + 4, cx + (_w*scale)/2 + 4, cy + (_h*scale)/2 + 4, false);
    draw_set_alpha(1.0);

    draw_set_color(col);
    draw_rectangle(cx - (_w*scale)/2, cy - (_h*scale)/2, cx + (_w*scale)/2, cy + (_h*scale)/2, false);
    
    draw_set_color(c_black);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text_transformed(cx, cy, _text, scale, scale, 0);
    draw_set_halign(fa_left); draw_set_valign(fa_top);
    
    return (hover && _clicked);
}