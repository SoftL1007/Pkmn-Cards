randomize();

// FULL LIST (36 Species)
all_species_ids = [
    "charizard", "blastoise", "venusaur", 
    "alakazam", "gengar", "gyarados", "snorlax", "machamp", "rhydon", 
    "jolteon", "dragonite", "arcanine",
    "typhlosion", "feraligatr", "meganium", 
    "tyranitar", "scizor", "heracross", "houndoom", "kingdra", 
    "skarmory", "umbreon", "espeon", "donphan",
    "blaziken", "swampert", "sceptile", 
    "gardevoir", "metagross", "salamence", "milotic", "aggron", 
    "flygon", "manectric", "tropius", "dusclops"
];

// Deck
player_deck = [
    "x_atk", "x_atk", "x_def", "x_def", 
    "x_spd", "x_spd", "potion_hyper", "potion_hyper",
    "potion_hyper", "revive", "x_atk", "revive"
];

// Shuffle
var n = array_length(player_deck);
for (var i = n - 1; i > 0; i--) {
    var j = irandom(i);
    var temp = player_deck[i];
    player_deck[i] = player_deck[j];
    player_deck[j] = temp;
}

// Player Party
player_party = [];
repeat(6) {
    array_push(player_party, create_random_pokemon(50));
}

function generate_enemy_team() {
    var team = [];
    repeat(6) {
        array_push(team, create_random_pokemon(50));
    }
    return team;
}

function create_random_pokemon(_level) {
    var r_species_index = irandom(array_length(all_species_ids) - 1);
    var species_id = all_species_ids[r_species_index];
    var species_data = get_pokemon_species(species_id);
    
    // Load Fixed Moves
    var my_moves = [];
    if (variable_struct_exists(species_data, "move_ids")) {
        var m_ids = species_data.move_ids;
        for (var i = 0; i < array_length(m_ids); i++) {
            array_push(my_moves, get_move_data(m_ids[i]));
        }
    } else {
        array_push(my_moves, get_move_data("tackle"));
    }
    
    return new Pokemon(species_data, _level, my_moves);
}