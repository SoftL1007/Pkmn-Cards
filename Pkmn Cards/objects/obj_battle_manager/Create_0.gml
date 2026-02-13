if (!instance_exists(obj_game_data)) instance_create_depth(0, 0, 0, obj_game_data);

player_team = obj_game_data.player_party;
player_deck = obj_game_data.player_deck;
enemy_team = obj_game_data.generate_enemy_team();

p_active_index = 0;
e_active_index = 0;

state = BATTLE_STATE.START; 
action_queue = [];
battle_log = "Battle Start!";
player_hand = [];
max_hand_size = 4; // UPDATED to 4

selected_move = -1;
selected_card = -1;
selected_switch_target = -1;

mulligan_available = true; 

screen_shake = 0;
p_flash_alpha = 0; 
e_flash_alpha = 0; 
p_offset_x = 0; p_offset_y = 0;
e_offset_x = 0; e_offset_y = 0;

u_time_uni_buff = shader_get_uniform(shd_buff, "u_time");
u_time_uni_debuff = shader_get_uniform(shd_debuff, "u_time");

card_anim_active = false;
card_anim_timer = 0;
card_anim_data = undefined;