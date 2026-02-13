/// @func get_type_effectiveness(_atk_type, _def_type)
/// @desc Returns Gen 3 multiplier (0, 0.5, 1, 2)
function get_type_effectiveness(_atk_type, _def_type) {
    // A simplified matrix for the prototype. 
    // You must fill this fully for a real game. 
    // Showing logic for Fire vs Water:
    
    if (_atk_type == ELEMENT.FIRE) {
        if (_def_type == ELEMENT.WATER) return 0.5;
        if (_def_type == ELEMENT.GRASS) return 2.0;
        if (_def_type == ELEMENT.STEEL) return 2.0;
    }
    if (_atk_type == ELEMENT.WATER) {
        if (_def_type == ELEMENT.FIRE) return 2.0;
        if (_def_type == ELEMENT.GRASS) return 0.5;
    }
    // ... Add all Gen 3 interactions here
    return 1.0;
}

/// @func calculate_damage(_attacker, _defender, _move)
/// @desc The Gen 3 Damage Formula
function calculate_damage(_attacker, _defender, _move) {
    if (_move.category == "STATUS") return 0;
    
    // 1. Determine Stats (Gen 3 Split by TYPE)
    // In Gen 3, Ghost is Physical, Dark is Special.
    var is_physical = false;
    
    // Explicit Gen 3 Physical Types
    var phys_types = [ELEMENT.NORMAL, ELEMENT.FIGHTING, ELEMENT.FLYING, ELEMENT.GROUND, 
                      ELEMENT.ROCK, ELEMENT.BUG, ELEMENT.GHOST, ELEMENT.POISON, ELEMENT.STEEL];
                      
    if (array_contains(phys_types, _move.type)) is_physical = true;
    
    var a = is_physical ? _attacker.stats.atk : _attacker.stats.spa;
    var d = is_physical ? _defender.stats.def : _defender.stats.spd;
    
    // 2. Base Damage Calculation
    // Formula: ((2 * Level / 5 + 2) * Power * A / D) / 50 + 2
    var level_factor = (2 * _attacker.level) / 5 + 2;
    var base_dmg = (level_factor * _move.base_power * (a / d)) / 50 + 2;
    
    // 3. Modifiers
    var multiplier = 1.0;
    
    // STAB (Same Type Attack Bonus)
    if (array_contains(_attacker.types, _move.type)) multiplier *= 1.5;
    
    // Type Effectiveness
    var type_mult = 1.0;
    for (var i = 0; i < array_length(_defender.types); i++) {
        type_mult *= get_type_effectiveness(_move.type, _defender.types[i]);
    }
    multiplier *= type_mult;
    
    // Critical Hit (Gen 3: ~6.25% chance)
    if (random(100) < 6.25) {
        multiplier *= 2.0;
        show_debug_message("CRITICAL HIT!");
    }
    
    // Random Variance (0.85 to 1.0)
    var rng = irandom_range(85, 100) / 100;
    
    return floor(base_dmg * multiplier * rng);
}

// Helper to find value in array
function array_contains(_arr, _val) {
    for(var i=0; i<array_length(_arr); i++) {
        if (_arr[i] == _val) return true;
    }
    return false;
}