// 1. Dependency Check
// If we test the room directly without the menu, this safety block creates the data object
// but assumes a local test environment.
if (!instance_exists(obj_game_data)) {
    instance_create_depth(0,0,0, obj_game_data);
    obj_game_data.set_player_slot(0, "charizard"); // Test mon
    obj_game_data.set_player_slot(1, "blastoise"); // Test mon
    obj_game_data.prepare_local_battle();
}

// 2. Consume Data from Persistent Object
// DO NOT generate new mons here. Reference the existing ones.
player_team = [];
enemy_team = [];

// Filter out 'undefined' slots from the array for the actual battle logic
// (Battle system expects packed arrays, not sparse ones with undefined)
var pt = obj_game_data.player_team;
for (var i = 0; i < array_length(pt); i++) {
    if (pt[i] != undefined) array_push(player_team, pt[i]);
}

var et = obj_game_data.enemy_team;
for (var i = 0; i < array_length(et); i++) {
    if (et[i] != undefined) array_push(enemy_team, et[i]);
}

// Deck
player_deck = obj_game_data.player_deck;

// Battle Logic Initialization (Keep existing)
p_active_index = 0;
e_active_index = 0;
state = BATTLE_STATE.START; 
action_queue = [];
battle_log = "Battle Start!";
player_hand = [];
max_hand_size = 4;

selected_move = -1;
selected_card = -1;
selected_switch_target = -1;
mulligan_available = true; 

// Visuals
screen_shake = 0;
p_flash_alpha = 0; e_flash_alpha = 0; 
p_offset_x = 0; p_offset_y = 0;
e_offset_x = 0; e_offset_y = 0;
u_time_uni_buff = shader_get_uniform(shd_buff, "u_time");
u_time_uni_debuff = shader_get_uniform(shd_red_throb, "u_time"); // Updated name from prompt check
card_anim_active = false;
card_anim_timer = 0;
card_anim_data = undefined;
turn_start_processed = false;
revive_target_index = -1;

// --- NEW VISUAL VARIABLES ---
battle_log_display = ""; // What is actually drawn (for typewriter effect)
bg_dim_alpha = 0;        // For darkening background during big moves
tooltip_text = "";       // For hovering info
tooltip_header = "";     
gui_margin = 4;          // For border thickness

// Add to existing variables
event_card_active = undefined; // Holds the struct of the temp heal card
event_card_timer = 0;          // Should last 1 turn
// max_hand_size is still 4