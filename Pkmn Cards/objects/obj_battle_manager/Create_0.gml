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

// Hand Visual Arrays
hand_visual_y = array_create(10, 1200); 

// State & Indexes
if (!waiting_for_connection) state = BATTLE_STATE.START;
p_active_index = 0;
e_active_index = 0;
action_queue = [];
turn_start_processed = false;

// Visual Scaling & Switch Logic (NEW)
p_scale = 1.0; 
e_scale = 1.0; 
switch_phase = 0; // 0=None, 1=Retract, 2=Expand
switch_processing_actor = "none";
switch_target_index = -1;
switch_timer = 0;

// Selection Variables
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

// --- PARTICLE SYSTEM SETUP ---
// We create the system here, we draw it manually in Draw GUI
global.part_sys = part_system_create();
part_system_automatic_draw(global.part_sys, false); 

// 1. AURA PARTICLES (Selected Card) - Yellow Aura
global.pt_aura = part_type_create();
part_type_shape(global.pt_aura, pt_shape_pixel);
part_type_size(global.pt_aura, 1, 2, -0.05, 0); 
part_type_color3(global.pt_aura, c_yellow, c_orange, c_white);
part_type_alpha3(global.pt_aura, 1, 0.8, 0);
part_type_speed(global.pt_aura, 1, 2.5, 0, 0);
part_type_direction(global.pt_aura, 80, 100, 0, 0); // Move Upwards
part_type_life(global.pt_aura, 20, 40);

// 2. SWITCH POOF (Explosion) - White Poof
// FIXED ERROR: Uses part_type_color1 now instead of RGB crash
global.pt_poof = part_type_create();
part_type_shape(global.pt_poof, pt_shape_disk);
part_type_size(global.pt_poof, 0.2, 0.5, -0.01, 0);
part_type_color1(global.pt_poof, c_white); 
part_type_alpha2(global.pt_poof, 1, 0);
part_type_speed(global.pt_poof, 2, 5, -0.1, 0);
part_type_direction(global.pt_poof, 0, 360, 0, 0); 
part_type_life(global.pt_poof, 15, 30);

function receive_network_action(_data) {
    online_enemy_action = _data;
    online_enemy_ready = true;
    if (online_player_ready && online_enemy_ready) {
        state = BATTLE_STATE.RESOLVE_PHASE;
    }
}

discard_selected_index = -1; // Tracks which card we want to throw away


text_char_delay = 2; // Higher = Slower typing (2 frames per char)
text_timer = 0;
switch_delay_timer = 0; // To pause before shrinking/expanding


// RESHUFFLE ANIMATION VARIABLES
reshuffle_anim_active = false;
reshuffle_timer = 0;