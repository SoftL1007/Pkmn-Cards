/// @desc Gen 3 Mechanics

function get_gen3_category(_type) {
    // Physical: Normal, Fight, Flying, Ground, Rock, Bug, Ghost, Poison, Steel
    var phys = [ELEMENT.NORMAL, ELEMENT.FIGHTING, ELEMENT.FLYING, ELEMENT.GROUND, 
                ELEMENT.ROCK, ELEMENT.BUG, ELEMENT.GHOST, ELEMENT.POISON, ELEMENT.STEEL];
    
    if (array_contains(phys, _type)) return "PHYSICAL";
    return "SPECIAL"; // Fire, Water, Grass, Elec, Ice, Psy, Drag, Dark
}

function get_type_effectiveness(_atk_type, _def_type) {
    // 1.0 is Neutral. 2.0 is Super Effective. 0.5 is Not Very Effective. 0.0 is Immune.
    
    switch (_atk_type) {
        case ELEMENT.NORMAL:
            if (_def_type == ELEMENT.ROCK || _def_type == ELEMENT.STEEL) return 0.5;
            if (_def_type == ELEMENT.GHOST) return 0.0;
            break;

        case ELEMENT.FIRE:
            if (_def_type == ELEMENT.GRASS || _def_type == ELEMENT.ICE || _def_type == ELEMENT.BUG || _def_type == ELEMENT.STEEL) return 2.0;
            if (_def_type == ELEMENT.FIRE || _def_type == ELEMENT.WATER || _def_type == ELEMENT.ROCK || _def_type == ELEMENT.DRAGON) return 0.5;
            break;

        case ELEMENT.WATER:
            if (_def_type == ELEMENT.FIRE || _def_type == ELEMENT.GROUND || _def_type == ELEMENT.ROCK) return 2.0;
            if (_def_type == ELEMENT.WATER || _def_type == ELEMENT.GRASS || _def_type == ELEMENT.DRAGON) return 0.5;
            break;

        case ELEMENT.GRASS:
            if (_def_type == ELEMENT.WATER || _def_type == ELEMENT.GROUND || _def_type == ELEMENT.ROCK) return 2.0;
            if (_def_type == ELEMENT.FIRE || _def_type == ELEMENT.GRASS || _def_type == ELEMENT.POISON || _def_type == ELEMENT.FLYING || _def_type == ELEMENT.BUG || _def_type == ELEMENT.DRAGON || _def_type == ELEMENT.STEEL) return 0.5;
            break;

        case ELEMENT.ELECTRIC:
            if (_def_type == ELEMENT.WATER || _def_type == ELEMENT.FLYING) return 2.0;
            if (_def_type == ELEMENT.GRASS || _def_type == ELEMENT.ELECTRIC || _def_type == ELEMENT.DRAGON) return 0.5;
            if (_def_type == ELEMENT.GROUND) return 0.0;
            break;

        case ELEMENT.ICE:
            if (_def_type == ELEMENT.GRASS || _def_type == ELEMENT.GROUND || _def_type == ELEMENT.FLYING || _def_type == ELEMENT.DRAGON) return 2.0;
            if (_def_type == ELEMENT.FIRE || _def_type == ELEMENT.WATER || _def_type == ELEMENT.ICE || _def_type == ELEMENT.STEEL) return 0.5;
            break;

        case ELEMENT.FIGHTING:
            if (_def_type == ELEMENT.NORMAL || _def_type == ELEMENT.ICE || _def_type == ELEMENT.ROCK || _def_type == ELEMENT.DARK || _def_type == ELEMENT.STEEL) return 2.0;
            if (_def_type == ELEMENT.POISON || _def_type == ELEMENT.FLYING || _def_type == ELEMENT.PSYCHIC || _def_type == ELEMENT.BUG) return 0.5;
            if (_def_type == ELEMENT.GHOST) return 0.0;
            break;

        case ELEMENT.POISON:
            if (_def_type == ELEMENT.GRASS) return 2.0;
            if (_def_type == ELEMENT.POISON || _def_type == ELEMENT.GROUND || _def_type == ELEMENT.ROCK || _def_type == ELEMENT.GHOST) return 0.5;
            if (_def_type == ELEMENT.STEEL) return 0.0;
            break;

        case ELEMENT.GROUND:
            if (_def_type == ELEMENT.FIRE || _def_type == ELEMENT.ELECTRIC || _def_type == ELEMENT.POISON || _def_type == ELEMENT.ROCK || _def_type == ELEMENT.STEEL) return 2.0;
            if (_def_type == ELEMENT.GRASS || _def_type == ELEMENT.BUG) return 0.5;
            if (_def_type == ELEMENT.FLYING) return 0.0;
            break;

        case ELEMENT.FLYING:
            if (_def_type == ELEMENT.GRASS || _def_type == ELEMENT.FIGHTING || _def_type == ELEMENT.BUG) return 2.0;
            if (_def_type == ELEMENT.ELECTRIC || _def_type == ELEMENT.ROCK || _def_type == ELEMENT.STEEL) return 0.5;
            break;

        case ELEMENT.PSYCHIC:
            if (_def_type == ELEMENT.FIGHTING || _def_type == ELEMENT.POISON) return 2.0;
            if (_def_type == ELEMENT.PSYCHIC || _def_type == ELEMENT.STEEL) return 0.5;
            if (_def_type == ELEMENT.DARK) return 0.0;
            break;

        case ELEMENT.BUG:
            if (_def_type == ELEMENT.GRASS || _def_type == ELEMENT.PSYCHIC || _def_type == ELEMENT.DARK) return 2.0;
            if (_def_type == ELEMENT.FIRE || _def_type == ELEMENT.FIGHTING || _def_type == ELEMENT.POISON || _def_type == ELEMENT.FLYING || _def_type == ELEMENT.GHOST || _def_type == ELEMENT.STEEL) return 0.5;
            break;

        case ELEMENT.ROCK:
            if (_def_type == ELEMENT.FIRE || _def_type == ELEMENT.ICE || _def_type == ELEMENT.FLYING || _def_type == ELEMENT.BUG) return 2.0;
            if (_def_type == ELEMENT.FIGHTING || _def_type == ELEMENT.GROUND || _def_type == ELEMENT.STEEL) return 0.5;
            break;

        case ELEMENT.GHOST:
            if (_def_type == ELEMENT.PSYCHIC || _def_type == ELEMENT.GHOST) return 2.0;
            if (_def_type == ELEMENT.DARK || _def_type == ELEMENT.STEEL) return 0.5;
            if (_def_type == ELEMENT.NORMAL) return 0.0;
            break;

        case ELEMENT.DRAGON:
            if (_def_type == ELEMENT.DRAGON) return 2.0;
            if (_def_type == ELEMENT.STEEL) return 0.5;
            break;

        case ELEMENT.STEEL:
            if (_def_type == ELEMENT.ICE || _def_type == ELEMENT.ROCK) return 2.0;
            if (_def_type == ELEMENT.FIRE || _def_type == ELEMENT.WATER || _def_type == ELEMENT.ELECTRIC || _def_type == ELEMENT.STEEL) return 0.5;
            break;

        case ELEMENT.DARK:
            if (_def_type == ELEMENT.PSYCHIC || _def_type == ELEMENT.GHOST) return 2.0;
            if (_def_type == ELEMENT.FIGHTING || _def_type == ELEMENT.DARK || _def_type == ELEMENT.STEEL) return 0.5;
            break;
    }

    return 1.0; 
}

function calculate_move_result(_attacker, _defender, _move) {
    var result = { 
        damage: 0, 
        message: "", 
        hit: true, 
        is_status: false,
        stat_change: { stat: "none", stages: 0 } 
    };
    
    // 1. Accuracy Check
    if (_move.accuracy < 100 && irandom(100) > _move.accuracy) {
        result.hit = false;
        result.message = "The attack missed!";
        return result;
    }

    // 2. CHECK FOR STATUS MOVES (0 Base Power)
    if (_move.base_power == 0) {
        result.is_status = true;
        
        switch(_move.id) {
            case "swords_dance":
                result.stat_change = { stat: "atk", stages: 2 };
                result.message = "Attack rose sharply!";
                break;
            case "calm_mind":
                result.stat_change = { stat: "spa", stages: 1 };
                result.message = "Sp. Atk rose!";
                break;
            case "dragon_dance":
                result.stat_change = { stat: "atk", stages: 1 };
                result.message = "Attack rose!";
                break;
            case "growl":
                result.stat_change = { stat: "atk", stages: -1 };
                result.message = "Attack fell!";
                break;
            case "tail_whip":
            case "leer":
                result.stat_change = { stat: "def", stages: -1 };
                result.message = "Defense fell!";
                break;
            default:
                result.message = "But it failed!";
        }
        return result;
    }
    
    // 3. DAMAGE CALCULATION
    var cat = get_gen3_category(_move.type);
    var a = (cat == "PHYSICAL") ? _attacker.stats.atk : _attacker.stats.spa;
    var d = (cat == "PHYSICAL") ? _defender.stats.def : _defender.stats.spd;
    
    var level_factor = (2 * _attacker.level) / 5 + 2;
    var base_dmg = (level_factor * _move.base_power * (a / d)) / 50 + 2;
    
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
    
    // Critical Hit
    var is_crit = (random(100) < 6.25);
    if (is_crit) multiplier *= 2.0;
    
    var rng = irandom_range(85, 100) / 100;
    
    result.damage = floor(base_dmg * multiplier * rng);
    
    if (type_mult == 0) result.message = "It had no effect...";
    else if (type_mult > 1) result.message = "It's super effective!";
    else if (type_mult < 1) result.message = "It's not very effective...";
    
    if (is_crit && type_mult > 0) result.message += " A critical hit!";
    
    return result;
}

function array_contains(_arr, _val) {
    for(var i=0; i<array_length(_arr); i++) {
        if (_arr[i] == _val) return true;
    }
    return false;
}