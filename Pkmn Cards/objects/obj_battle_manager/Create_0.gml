// --------------------------------------------------------
// BATTLE MANAGER - CREATE EVENT
// --------------------------------------------------------
randomize();

if (!instance_exists(obj_game_data)) {
    instance_create_depth(0,0,0, obj_game_data);
    obj_game_data.set_player_slot(0, "charizard");
    obj_game_data.set_player_slot(1, "blastoise");
    obj_game_data.prepare_local_battle();
}

// Player Team
player_team = [];
var pt = obj_game_data.player_team;
for (var i = 0; i < array_length(pt); i++) {
    if (pt[i] != undefined) {
        pt[i].display_hp = pt[i].current_hp; 
        array_push(player_team, pt[i]);
    }
}

// Enemy Team & Network
enemy_team = [];
waiting_for_connection = false; 

if (obj_game_data.game_mode == "ONLINE") {
    var has_net_data = (instance_exists(obj_network_manager) && array_length(obj_network_manager.opponent_team_data) > 0);
    
    if (has_net_data) {
        var op_data = obj_network_manager.opponent_team_data;
        for (var i = 0; i < array_length(op_data); i++) {
            var slot = op_data[i];
            if (slot != undefined) {
                var s_id = variable_struct_exists(slot, "species_id") ? slot.species_id : "charizard";
                var species = get_pokemon_species(s_id);
                var m_moves = [];
                if (variable_struct_exists(species, "move_ids")) {
                    for(var k=0; k<array_length(species.move_ids); k++) array_push(m_moves, get_move_data(species.move_ids[k]));
                }
                var new_mon = new Pokemon(species, 50, m_moves);
                new_mon.nickname = slot.nickname;
                new_mon.display_hp = new_mon.current_hp;
                array_push(enemy_team, new_mon);
            }
        }
        battle_log = "Connected! Battle Start!";
    } 
    else {
        waiting_for_connection = true; 
        state = BATTLE_STATE.WAIT;
        battle_log = "Waiting for Opponent Connection...";
    }
}
else {
    var et = obj_game_data.enemy_team;
    for (var i = 0; i < array_length(et); i++) {
        if (et[i] != undefined) {
             et[i].display_hp = et[i].current_hp;
             array_push(enemy_team, et[i]);
        }
    }
    battle_log = "Battle Start!";
}

// Deck & Hand
player_deck = obj_game_data.player_deck; 
player_hand = [];
max_hand_size = 4;
mulligan_available = true; 
event_card_active = undefined;
event_card_timer = 0;

// *** NEW: HAND ANIMATION ARRAYS ***
// We initialize this with off-screen values (1200) so cards float up when drawn
hand_visual_y = array_create(10, 1200); 

// State
if (!waiting_for_connection) state = BATTLE_STATE.START;
p_active_index = 0;
e_active_index = 0;
action_queue = [];
turn_start_processed = false;

// Selection Variables (Set to -1)
selected_move = -1;
selected_card = -1; 
selected_switch_target = -1;
revive_target_index = -1;

// Visuals
screen_shake = 0;
p_flash_alpha = 0; e_flash_alpha = 0; 
p_offset_x = 0; p_offset_y = 0;
e_offset_x = 0; e_offset_y = 0;
bg_dim_alpha = 0;

u_time_uni_buff = shader_get_uniform(shd_buff, "u_time");
u_time_uni_debuff = shader_get_uniform(shd_red_throb, "u_time");

card_anim_active = false;
card_anim_phase = 0; 
card_anim_y = 1200;  
card_anim_data = undefined;

battle_log_display = "";
tooltip_text = "";
tooltip_header = "";     

online_player_ready = false; 
online_enemy_ready = false;  
online_my_action = undefined;
online_enemy_action = { move_index: -1, card_index: -1, switch_index: -1, card_id_str: "none" };

function receive_network_action(_data) {
    online_enemy_action = _data;
    online_enemy_ready = true;
    if (online_player_ready && online_enemy_ready) {
        state = BATTLE_STATE.RESOLVE_PHASE;
    }
}