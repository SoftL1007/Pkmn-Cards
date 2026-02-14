// Smooth Slide Animation
menu_anim_y = lerp(menu_anim_y, target_anim_y, 0.1);

// Mouse Wheel Logic for Team Builder
if (state == MENU_STATE.TEAM_BUILDER) {
    if (mouse_wheel_up()) scroll_offset = max(0, scroll_offset - 1);
    if (mouse_wheel_down()) {
        // Calculate max scroll based on current tab
        var max_items = 12; // 12 mons per gen in the list
        var max_scroll = max(0, max_items - items_per_page);
        scroll_offset = min(max_scroll, scroll_offset + 1);
    }
}