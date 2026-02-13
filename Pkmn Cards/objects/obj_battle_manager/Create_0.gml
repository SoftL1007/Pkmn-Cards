randomize();

// 1. Setup State
state = BATTLE_STATE.START;
action_queue = [];
battle_log = "Battle Start!";

// 2. Setup Player Deck & Hand
// We store IDs (strings), then look them up when needed
player_deck = ["x_def", "x_def", "x_def", "x_spd", "x_atk"]; 
player_hand = []; 
max_hand_size = 5;

// 3. Initialize Player Pokemon (Fetch from DB)
// Helper to build move list easily
var p_moves = [
    get_move_data("blaze_kick"),
    get_move_data("sky_uppercut"),
    get_move_data("quick_attack"),
    get_move_data("aerial_ace")
];

var p_data = get_pokemon_species("blaziken");
player_pokemon = new Pokemon(p_data, 50, p_moves);

// 4. Initialize Enemy Pokemon (Fetch from DB)
var e_moves = [
    get_move_data("tackle"),
    get_move_data("tackle"),
    get_move_data("tackle"),
    get_move_data("tackle")
];

var e_data = get_pokemon_species("swampert");
enemy_pokemon = new Pokemon(e_data, 50, e_moves);

// UI Communication variables
selected_move = -1;
selected_card = -1;

// Start the loop
state = BATTLE_STATE.DRAW_PHASE;