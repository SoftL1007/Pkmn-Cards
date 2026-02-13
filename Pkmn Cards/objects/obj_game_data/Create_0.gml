// This object holds the "Save File" data
randomize();

// 1. Player's Saved Team
// This will eventually be modified by your Team Builder UI
player_party = []; 
player_deck = ["x_atk", "x_atk", "x_def", "x_spd", "x_atk"];

// 2. Function to load a specific test team (since we don't have a menu yet)
function load_test_party() {
    player_party = [];
    
    // Create Blaziken
    var p1 = new Pokemon(get_pokemon_species("charizard"), 50, [
        get_move_data("blaze_kick"), get_move_data("sky_uppercut"), get_move_data("quick_attack"), get_move_data("aerial_ace")
    ]);
    
    // Create Gardevoir
    var p2 = new Pokemon(get_pokemon_species("alakazam"), 50, [
        get_move_data("psychic"), get_move_data("tackle"), get_move_data("tackle"), get_move_data("tackle")
    ]);
    
    array_push(player_party, p1);
    array_push(player_party, p2);
}

// 3. Helper to generate a random enemy team
function generate_enemy_team() {
    var team = [];
    
    // Swampert
    var e1 = new Pokemon(get_pokemon_species("blastoise"), 50, [
        get_move_data("surf"), get_move_data("earthquake"), get_move_data("muddy_water"), get_move_data("tackle")
    ]);
    
    // Random second mon (Mightyena or Swellow)
    var species = (random(100) < 50) ? "arcanine" : "swellow";
    var e2 = new Pokemon(get_pokemon_species(species), 50, [
        get_move_data("tackle"), get_move_data("bite"), get_move_data("quick_attack"), get_move_data("aerial_ace")
    ]);
    
    array_push(team, e1);
    array_push(team, e2);
    
    return team;
}

// Initialize for now (Simulating that we just came from the builder)
load_test_party();