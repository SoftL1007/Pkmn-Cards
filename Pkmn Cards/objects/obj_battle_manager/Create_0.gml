// Ensure Game Data exists (Prevent crashes if you run the room directly)
if (!instance_exists(obj_game_data)) {
    instance_create_depth(0, 0, 0, obj_game_data);
}

// 1. IMPORT DATA FROM PERSISTENT OBJECT
player_team = obj_game_data.player_party; // Link to the existing team
player_deck = obj_game_data.player_deck;

// 2. GENERATE ENEMY
// In the future, this might come from an 'obj_enemy_npc' collision
enemy_team = obj_game_data.generate_enemy_team();

// 3. Setup Battle Indices
p_active_index = 0;
e_active_index = 0;

// 4. State Setup
state = BATTLE_STATE.DRAW_PHASE;
action_queue = [];
battle_log = "Battle Start!";
player_hand = [];
max_hand_size = 5;

// Inputs
selected_move = -1;
selected_card = -1;
selected_switch_target = -1;


// --- VISUAL FX VARIABLES ---
screen_shake = 0;
p_flash_alpha = 0; // Player flash (0 = none, 1 = white)
e_flash_alpha = 0; // Enemy flash

// Sprite Animation Offsets (For lunging when attacking)
p_offset_x = 0;
p_offset_y = 0;
e_offset_x = 0;
e_offset_y = 0;