/// @desc Gen 3 Mechanics

/// @func get_gen3_category(_type)
/// @desc Returns "PHYSICAL" or "SPECIAL" based on Type (Gen 3 Rules)
function get_gen3_category(_type) {
    // Physical: Normal, Fight, Flying, Ground, Rock, Bug, Ghost, Poison, Steel
    var phys = [ELEMENT.NORMAL, ELEMENT.FIGHTING, ELEMENT.FLYING, ELEMENT.GROUND, 
                ELEMENT.ROCK, ELEMENT.BUG, ELEMENT.GHOST, ELEMENT.POISON, ELEMENT.STEEL];
    
    if (array_contains(phys, _type)) return "PHYSICAL";
    return "SPECIAL"; // Fire, Water, Grass, Elec, Ice, Psy, Drag, Dark
}

/// @func get_type_effectiveness(_atk_type, _def_type)
function get_type_effectiveness(_atk_type, _def_type) {
    // Simplified Chart for Prototype
    // 2.0 = Super Effective, 0.5 = Not Very, 0.0 = Immune
    
    if (_atk_type == ELEMENT.FIRE) {
        if (_def_type == ELEMENT.GRASS || _def_type == ELEMENT.ICE || _def_type == ELEMENT.STEEL || _def_type == ELEMENT.BUG) return 2.0;
        if (_def_type == ELEMENT.WATER || _def_type == ELEMENT.FIRE || _def_type == ELEMENT.ROCK || _def_type == ELEMENT.DRAGON) return 0.5;
    }
    if (_atk_type == ELEMENT.WATER) {
        if (_def_type == ELEMENT.FIRE || _def_type == ELEMENT.GROUND || _def_type == ELEMENT.ROCK) return 2.0;
        if (_def_type == ELEMENT.WATER || _def_type == ELEMENT.GRASS || _def_type == ELEMENT.DRAGON) return 0.5;
    }
    if (_atk_type == ELEMENT.GRASS) {
        if (_def_type == ELEMENT.WATER || _def_type == ELEMENT.GROUND || _def_type == ELEMENT.ROCK) return 2.0;
        if (_def_type == ELEMENT.FIRE || _def_type == ELEMENT.GRASS || _def_type == ELEMENT.POISON || _def_type == ELEMENT.FLYING || _def_type == ELEMENT.BUG || _def_type == ELEMENT.DRAGON || _def_type == ELEMENT.STEEL) return 0.5;
    }
    if (_atk_type == ELEMENT.GROUND) {
        if (_def_type == ELEMENT.FLYING) return 0.0; // IMMUNITY
        if (_def_type == ELEMENT.FIRE || _def_type == ELEMENT.ELECTRIC || _def_type == ELEMENT.POISON || _def_type == ELEMENT.ROCK || _def_type == ELEMENT.STEEL) return 2.0;
    }
    if (_atk_type == ELEMENT.ELECTRIC) {
        if (_def_type == ELEMENT.GROUND) return 0.0; // IMMUNITY
        if (_def_type == ELEMENT.WATER || _def_type == ELEMENT.FLYING) return 2.0;
    }
    if (_atk_type == ELEMENT.FIGHTING) {
        if (_def_type == ELEMENT.GHOST) return 0.0; // IMMUNITY
    }
    if (_atk_type == ELEMENT.NORMAL) {
        if (_def_type == ELEMENT.GHOST) return 0.0; // IMMUNITY
    }
    
    return 1.0; // Default Neutral
}

/// @func calculate_damage_gen3(_attacker, _defender, _move)
/// @desc Returns a Struct: { damage: int, message: string }
function calculate_damage_gen3(_attacker, _defender, _move) {
    var result = { damage: 0, message: "" };
    
    if (_move.base_power == 0) return result; // Status moves
    
    // 1. Determine Category (Gen 3 Split)
    var cat = get_gen3_category(_move.type);
    
    var a = (cat == "PHYSICAL") ? _attacker.stats.atk : _attacker.stats.spa;
    var d = (cat == "PHYSICAL") ? _defender.stats.def : _defender.stats.spd;
    
    // 2. Base Damage
    var level_factor = (2 * _attacker.level) / 5 + 2;
    var base_dmg = (level_factor * _move.base_power * (a / d)) / 50 + 2;
    
    // 3. Modifiers
    var multiplier = 1.0;
    
    // STAB
    if (array_contains(_attacker.types, _move.type)) {
        multiplier *= 1.5;
    }
    
    // Type Effectiveness
    var type_mult = 1.0;
    for (var i = 0; i < array_length(_defender.types); i++) {
        type_mult *= get_type_effectiveness(_move.type, _defender.types[i]);
    }
    multiplier *= type_mult;
    
    // Critical Hit (Gen 3: ~6.25%)
    var is_crit = (random(100) < 6.25);
    if (is_crit) multiplier *= 2.0;
    
    // Random Variance (0.85 to 1.00)
    var rng = irandom_range(85, 100) / 100;
    
    // Final Calc
    result.damage = floor(base_dmg * multiplier * rng);
    
    // 4. Generate Feedback Message
    if (type_mult == 0) result.message = "It had no effect...";
    else if (type_mult > 1) result.message = "It's super effective!";
    else if (type_mult < 1) result.message = "It's not very effective...";
    
    if (is_crit) result.message += " A critical hit!";
    
    return result;
}

// Helper
function array_contains(_arr, _val) {
    for(var i=0; i<array_length(_arr); i++) {
        if (_arr[i] == _val) return true;
    }
    return false;
}