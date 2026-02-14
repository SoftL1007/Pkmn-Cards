// Clean Up Event
if (is_server && server_socket >= 0) {
    network_destroy(server_socket);
    server_socket = -1;
}
if (client_socket >= 0) {
    network_destroy(client_socket);
    client_socket = -1;
}
if (buffer_exists(net_buffer)) {
    buffer_delete(net_buffer);
}