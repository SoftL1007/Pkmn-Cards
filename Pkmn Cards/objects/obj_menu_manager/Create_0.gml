/// @desc Menu State Machine & Visuals
display_set_gui_size(1920, 1080);

enum MENU_STATE { MAIN, TEAM_BUILDER, MODE_SELECT, OPTIONS }
state = MENU_STATE.MAIN;

// UI State
selected_slot = -1; // For Team Builder
scroll_offset = 0;
current_tab = 0;    // 0 = Gen 1, 1 = Gen 2, 2 = Gen 3
items_per_page = 12;

// Visual "Juice" Variables
menu_anim_y = 0;        // Vertical slide offset
target_anim_y = 0;      
hover_scale = 1.0;
menu_font = fnt_game; 

// Button Helper with Juice
function draw_button_juicy(_x, _y, _w, _h, _text, _mx, _my, _clicked) {
    var hover = point_in_rectangle(_mx, _my, _x, _y, _x+_w, _y+_h);
    
    // Juice: Scale and Color
    var scale = hover ? 1.05 : 1.0;
    var col = hover ? c_lime : c_gray;
    if (_clicked && hover) col = c_white; // Flash on click
    
    // Draw centered on position to make scaling look good
    var center_x = _x + _w/2;
    var center_y = _y + _h/2;
    
    draw_set_color(col);
    // Draw rectangle centered
    draw_rectangle(center_x - (_w*scale)/2, center_y - (_h*scale)/2, 
                   center_x + (_w*scale)/2, center_y + (_h*scale)/2, false);
    
    draw_set_color(c_black);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text_transformed(center_x, center_y, _text, scale, scale, 0);
    draw_set_halign(fa_left); draw_set_valign(fa_top);
    
    return (hover && _clicked);
}