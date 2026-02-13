/// @desc Game Data & Random Generation Logic
randomize();

// ====================================================
// 1. MASTER LISTS (For Random Selection)
// ====================================================

// List of every Pokemon ID in your database
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

// List of every Move ID in your database
all_move_ids = [
    "tackle", "body_slam", "hyper_beam", "quick_attack", "slash",
    "flamethrower", "fire_blast", "ember",
    "surf", "hydro_pump", "water_gun", "scald", "waterfall", "muddy_water",
    "thunderbolt", "thunder", "thunder_punch",
    "razor_leaf", "solar_beam", "vine_whip", "giga_drain", "leaf_blade",
    "psychic", "psybeam", "extrasensory", "calm_mind",
    "ice_beam", "blizzard", "icy_wind", "ice_punch",
    "earthquake", "dig", "mud_slap",
    "rock_slide", "rollout", "rock_tomb",
    "wing_attack", "fly", "aerial_ace", "air_slash",
    "shadow_ball", "shadow_punch", "shadow_claw",
    "dragon_rage", "dragon_breath", "dragon_claw", "dragon_dance",
    "karate_chop", "submission", "dynamic_punch", "cross_chop", "sky_uppercut", "brick_break",
    "poison_sting", "sludge",
    "bug_buzz", "signal_beam",
    "crunch", "pursuit", "thief",
    "iron_tail", "steel_wing",
    "return", "crush_claw", "facade"
];

// ====================================================
// 2. PLAYER DATA
// ====================================================

player_party = []; 
// Make sure IDs match scr_database_cards EXACTLY
player_deck = ["x_atk", "x_atk", "x_def", "x_spd", "potion_hyper", "potion_hyper"];

// ====================================================
// 3. GENERATOR FUNCTIONS
// ====================================================

/// @func create_random_pokemon(_level)
/// @desc Creates a Pokemon with random Species and 4 Unique Random Moves
function create_random_pokemon(_level) {
    
    // A. Pick Random Species
    var r_species_index = irandom(array_length(all_species_ids) - 1);
    var species_id = all_species_ids[r_species_index];
    var species_data = get_pokemon_species(species_id);
    
    // B. Pick 4 Unique Moves
    var my_moves = [];
    
    // Create a temporary copy of the move list to pick from so we don't pick duplicates
    var move_pool = array_create(array_length(all_move_ids));
    array_copy(move_pool, 0, all_move_ids, 0, array_length(all_move_ids));
    
    repeat(4) {
        // Pick random index from pool
        var pool_idx = irandom(array_length(move_pool) - 1);
        var move_id = move_pool[pool_idx];
        
        // Add move data to pokemon
        array_push(my_moves, get_move_data(move_id));
        
        // Remove from pool so we don't pick it again
        array_delete(move_pool, pool_idx, 1);
    }
    
    // C. Return the new Pokemon Object
    return new Pokemon(species_data, _level, my_moves);
}

/// @func generate_random_team(_count, _level)
/// @desc Returns an array of random Pokemon
function generate_random_team(_count, _level) {
    var team = [];
    repeat(_count) {
        array_push(team, create_random_pokemon(_level));
    }
    return team;
}

// ====================================================
// 4. INITIALIZATION
// ====================================================

// Generate Player Team (6 Pokemon, Level 50)
player_party = generate_random_team(6, 50);

// Helper function for the Battle Manager to call later
function generate_enemy_team() {
    // Generate Enemy Team (6 Pokemon, Level 50)
    return generate_random_team(6, 50);
}