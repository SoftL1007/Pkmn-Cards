var type = ds_map_find_value(async_load, "type");
var socket_id = ds_map_find_value(async_load, "id");
var my_socket = (is_server) ? server_socket : client_socket;

// 1. CONNECTION HANDLING
if (type == network_type_connect) {
    if (is_server) {
        var sock = ds_map_find_value(async_load, "socket");
        connected_socket = sock; // Save the client's ID
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

// 2. DATA HANDLING (Receiving Teams & Moves)
else if (type == network_type_data) {
    var buffer = ds_map_find_value(async_load, "buffer");
    buffer_seek(buffer, buffer_seek_start, 0);
    
    // Prevent sticking packets by reading until empty
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        try {
            var msg_id = buffer_read(buffer, buffer_u8);
            var json_str = buffer_read(buffer, buffer_string);
            var data = json_parse(json_str);
            
            switch (msg_id) {
                case NETWORK_MSG.HANDSHAKE:
                    // Client received Host's hello -> Send Client's team back
                    if (!is_server) {
                        connected = true;
                        send_my_team();
                    }
                    break;
                
                case NETWORK_MSG.TEAM_DATA:
                    // Save the enemy team. 
                    // The Battle Manager Step Event (Step 2 above) will see this and start the game!
                    opponent_team_received = true;
                    opponent_team_data = data.team;
                    break;
                    
                case NETWORK_MSG.SUBMIT_ACTION:
                    // Unfreeze the turn
                    if (instance_exists(obj_battle_manager)) {
                        obj_battle_manager.receive_network_action(data);
                    }
                    break;
            }
        } catch(e) {
            // Stop crash if a packet is corrupted
            break; 
        }
    }
}