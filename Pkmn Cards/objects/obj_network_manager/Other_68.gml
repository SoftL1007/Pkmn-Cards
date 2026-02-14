var type = ds_map_find_value(async_load, "type");
var socket_id = ds_map_find_value(async_load, "id");
var my_socket = (is_server) ? server_socket : client_socket;

// 1. CONNECTION HANDLING
if (type == network_type_connect) {
    if (is_server) {
        var sock = ds_map_find_value(async_load, "socket");
        connected_socket = sock; 
        connected = true;
        // As soon as they connect, say hello AND send our team
        send_handshake(); 
        send_my_team(); 
    }
}
else if (type == network_type_disconnect) {
    connected = false;
    connected_socket = -1;
    if (instance_exists(obj_battle_manager)) obj_battle_manager.battle_log = "Opponent Disconnected!";
}

// 2. DATA HANDLING
else if (type == network_type_data) {
    var buffer = ds_map_find_value(async_load, "buffer");
    buffer_seek(buffer, buffer_seek_start, 0);
    
    // Read until buffer is empty to prevent sticky packets
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        try {
            var msg_id = buffer_read(buffer, buffer_u8);
            var json_str = buffer_read(buffer, buffer_string);
            var data = json_parse(json_str);
            
            switch (msg_id) {
                case NETWORK_MSG.HANDSHAKE:
                    // If we are the client, send our team back when we hear 'Hello'
                    if (!is_server) {
                        connected = true;
                        send_my_team();
                    }
                    break;
                
                case NETWORK_MSG.TEAM_DATA:
                    // === THE FIX IS HERE ===
                    // 1. We received a list of species names (strings)
                    var raw_list = data.team;
                    var final_enemy_team = array_create(6, undefined);
                    
                    // 2. Convert Strings -> Real Pokemon Structs
                    // We need to access get_pokemon_species and get_move_data
                    // Assuming these are global scripts. If they are methods of game_data, use 'with(obj_game_data)'
                    
                    for (var i = 0; i < array_length(raw_list); i++) {
                        var slot_data = raw_list[i];
                        if (slot_data != undefined) {
                            var spec_id = slot_data.species_id;
                            
                            // Recreate the Pokemon
                            // Note: Calling global script. 
                            var s_data = get_pokemon_species(spec_id);
                            
                            // Recreate Moves (Logic from obj_game_data)
                            var m_moves = [];
                            if (variable_struct_exists(s_data, "move_ids")) {
                                for(var k=0; k<array_length(s_data.move_ids); k++) {
                                    array_push(m_moves, get_move_data(s_data.move_ids[k]));
                                }
                            }
                            
                            // Build Object
                            var new_mon = new Pokemon(s_data, 50, m_moves);
                            new_mon.nickname = slot_data.nickname;
                            final_enemy_team[i] = new_mon;
                        }
                    }
                    
                    // 3. Inject into Game Data
                    obj_game_data.enemy_team = final_enemy_team;
                    
                    // 4. Inject into Battle Manager (Kickstarts the game!)
                    if (instance_exists(obj_battle_manager)) {
                        obj_battle_manager.enemy_team = final_enemy_team;
                        // Force initial refresh if needed
                        obj_battle_manager.battle_log = "Connection established! Battle Start!";
                    }
                    
                    opponent_team_received = true;
                    break;
                    
                case NETWORK_MSG.SUBMIT_ACTION:
                    // Unfreeze the turn
                    if (instance_exists(obj_battle_manager)) {
                        obj_battle_manager.receive_network_action(data);
                    }
                    break;
            }
        } catch(e) {
            break; 
        }
    }
}