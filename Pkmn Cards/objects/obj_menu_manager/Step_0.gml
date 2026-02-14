// Smooth Slide
menu_anim_y = lerp(menu_anim_y, target_anim_y, 0.1);

// Typing Logic for IP Address
if (state == MENU_STATE.ONLINE_LOBBY && is_typing_ip) {
    if (keyboard_check_pressed(vk_anykey)) {
        // Backspace
        if (keyboard_key == vk_backspace) {
            join_ip_string = string_delete(join_ip_string, string_length(join_ip_string), 1);
        }
        // Enter to finish
        else if (keyboard_key == vk_enter) {
            is_typing_ip = false;
        }
        // Typing numbers/dots
        else if (string_length(keyboard_string) > 0) {
            var char = string_char_at(keyboard_string, string_length(keyboard_string));
            // Only allow numbers and dots
            if (string_digits(char) != "" || char == ".") {
                join_ip_string += char;
            }
            keyboard_string = "";
        }
    }
}

// Mouse Wheel for Team Builder
if (state == MENU_STATE.TEAM_BUILDER) {
    if (mouse_wheel_up()) scroll_offset = max(0, scroll_offset - 1);
    if (mouse_wheel_down()) {
        var max_items = 12; 
        var max_scroll = max(0, max_items - items_per_page);
        scroll_offset = min(max_scroll, scroll_offset + 1);
    }
}