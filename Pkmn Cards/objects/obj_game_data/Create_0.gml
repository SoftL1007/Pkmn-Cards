/// @desc Persistent Data & Team Holder
randomize();

// 1. MASTER LISTS
all_species_ids = [
    "charizard", "blastoise", "venusaur", 
    "alakazam", "gengar", "gyarados", "snorlax", "machamp", "rhydon", 
    "jolteon", "dragonite", "arcanine", // Gen 1 (Indices 0-11)
    
    "typhlosion", "feraligatr", "meganium", 
    "tyranitar", "scizor", "heracross", "houndoom", "kingdra", 
    "skarmory", "umbreon", "espeon", "donphan", // Gen 2 (Indices 12-23)
    
    "blaziken", "swampert", "sceptile", 
    "gardevoir", "metagross", "salamence", "milotic", "aggron", 
    "flygon", "manectric", "tropius", "dusclops" // Gen 3 (Indices 24-35)
];

// 2. PLAYER DATA
player_team = array_create(6, undefined); 

// Master Deck Definition
master_deck_list = [
    "x_atk", "x_def", "x_spe", "growl_card", "leer_card", 
    "counter_trap", "poison_barb", "x_atk_2", "will_o_wisp_c",
    "protect_trap", "static_trap", "quick_claw", "charm", 
    "double_team", "x_spa", "x_spd", "mirror_coat"
];

// Current Deck (starts as copy of master)
player_deck = [];
array_copy(player_deck, 0, master_deck_list, 0, array_length(master_deck_list));

// 3. BATTLE CONTEXT
enemy_team = [];
game_mode = "LOCAL"; 

// --- HELPER FUNCTIONS ---

function set_player_slot(_index, _species_id) {
    if (_index < 0 || _index >= 6) return;
    var species_data = get_pokemon_species(_species_id);
    var my_moves = [];
    if (variable_struct_exists(species_data, "move_ids")) {
        var m_ids = species_data.move_ids;
        for (var i = 0; i < array_length(m_ids); i++) {
            array_push(my_moves, get_move_data(m_ids[i]));
        }
    } else {
        array_push(my_moves, get_move_data("tackle"));
    }
    player_team[_index] = new Pokemon(species_data, 50, my_moves);
}

function prepare_local_battle() {
    // Validate Team - if empty, fill slot 0
    var valid_count = 0;
    for (var i = 0; i < 6; i++) if (player_team[i] != undefined) valid_count++;
    if (valid_count == 0) set_player_slot(0, "charizard");
    
    // Generate AI
    enemy_team = [];
    repeat(6) {
        var r_id = all_species_ids[irandom(array_length(all_species_ids)-1)];
        var s_data = get_pokemon_species(r_id);
        var m_moves = [];
        if (variable_struct_exists(s_data, "move_ids")) {
            for(var k=0; k<array_length(s_data.move_ids); k++) array_push(m_moves, get_move_data(s_data.move_ids[k]));
        }
        array_push(enemy_team, new Pokemon(s_data, 50, m_moves));
    }
    
    // Reset and Shuffle Deck
    player_deck = [];
    array_copy(player_deck, 0, master_deck_list, 0, array_length(master_deck_list));
    deck_shuffle();
}

function deck_shuffle() {
    var n = array_length(player_deck);
    for (var i = n - 1; i > 0; i--) {
        var j = irandom(i);
        var temp = player_deck[i];
        player_deck[i] = player_deck[j];
        player_deck[j] = temp;
    }
}

// --- INITIALIZE DEFAULT TEAM ---
// Auto-fill the first 6 Pokemon so the user doesn't start with an empty team
for(var i=0; i<6; i++) {
    set_player_slot(i, all_species_ids[i]);
}
deck_shuffle();