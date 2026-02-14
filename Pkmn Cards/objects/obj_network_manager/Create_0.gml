/// @desc Network Setup
persistent = true; 

is_server = false;
server_socket = -1;
client_socket = -1;
connected_socket = -1; 
port = 7777;

net_buffer = buffer_create(4096, buffer_grow, 1);

connected = false;
opponent_team_received = false;
opponent_team_data = []; 

/// @func start_server(_port)
function start_server(_port) {
    port = _port;
    is_server = true;
    server_socket = network_create_server(network_socket_tcp, port, 1);
    if (server_socket < 0) {
        show_message("Error: Port " + string(port) + " blocked.");
        instance_destroy();
    }
}

/// @func connect_to_server(_ip, _port)
function connect_to_server(_ip, _port) {
    port = _port;
    is_server = false;
    client_socket = network_create_socket(network_socket_tcp);
    var res = network_connect(client_socket, _ip, port);
    if (res < 0) {
        show_message("Error: Could not connect to " + _ip);
        instance_destroy();
    }
}

/// @func send_packet(_msg_id, _data_struct)
function send_packet(_msg_id, _data_struct) {
    buffer_seek(net_buffer, buffer_seek_start, 0);
    buffer_write(net_buffer, buffer_u8, _msg_id);
    var json_str = json_stringify(_data_struct);
    buffer_write(net_buffer, buffer_string, json_str);
    
    if (is_server) {
        // Only send if we have a valid client
        if (connected_socket >= 0) { 
             network_send_packet(connected_socket, net_buffer, buffer_tell(net_buffer));
        }
    } else {
        network_send_packet(client_socket, net_buffer, buffer_tell(net_buffer));
    }
}

function send_handshake() {
    send_packet(NETWORK_MSG.HANDSHAKE, { msg: "Hello" });
}

function send_my_team() {
    var simplified_team = array_create(6, undefined);
    for (var i = 0; i < 6; i++) {
        var mon = obj_game_data.player_team[i];
        if (mon != undefined) {
            simplified_team[i] = {
                species_id: string_lower(mon.species_name), 
                nickname: mon.nickname
            };
        }
    }
    send_packet(NETWORK_MSG.TEAM_DATA, { team: simplified_team });
}