/// @desc Gen 3 Mechanics & Type Chart

/// @func get_gen3_category(_type)
function get_gen3_category(_type) {
    // Physical: Normal, Fight, Flying, Ground, Rock, Bug, Ghost, Poison, Steel
    var phys = [ELEMENT.NORMAL, ELEMENT.FIGHTING, ELEMENT.FLYING, ELEMENT.GROUND, 
                ELEMENT.ROCK, ELEMENT.BUG, ELEMENT.GHOST, ELEMENT.POISON, ELEMENT.STEEL];
    
    if (array_contains(phys, _type)) return "PHYSICAL";
    return "SPECIAL"; // Fire, Water, Grass, Elec, Ice, Psy, Drag, Dark
}

/// @func get_type_effectiveness(_atk_type, _def_type)
function get_type_effectiveness(_atk_type, _def_type) {
    // 1.0 = Neutral, 2.0 = Super Effective, 0.5 = Not Very Effective, 0.0 = Immune
    
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

    return 1.0; // Default Neutral
}

/// @func calculate_move_result(_attacker, _defender, _move)
function calculate_move_result(_attacker, _defender, _move) {
    var result = { 
        damage: 0, 
        heal: 0,      // NEW: For Giga Drain
        recoil: 0,    // NEW: For Double Edge
        message: "", 
        hit: true, 
        is_status: false,
        stat_change: { stat: "none", stages: 0, target: SCOPE.ENEMY },
        condition_change: { condition: "none", target: SCOPE.ENEMY }
    };
    
    // 1. Accuracy Check
    // (Bypass accuracy for "Swift" or similar moves if added, otherwise standard)
    if (_move.accuracy < 100 && _move.accuracy > 0 && irandom(100) > _move.accuracy) {
        result.hit = false;
        result.message = "The attack missed!";
        return result;
    }

    // 2. CHECK FOR PURE STATUS MOVES (BP 0)
    if (_move.base_power == 0) {
        result.is_status = true;
        
        // A) Stat Change
        if (variable_struct_exists(_move.effect, "stat") && _move.effect.stat != "none") {
            result.stat_change = {
                stat: _move.effect.stat,
                stages: _move.effect.amount,
                target: _move.effect.target
            };
            var s_name = _move.effect.stat; 
            switch(s_name) {
                case "atk": s_name = "Attack"; break;
                case "def": s_name = "Defense"; break;
                case "spa": s_name = "Sp. Atk"; break;
                case "spd": s_name = "Sp. Def"; break;
                case "spe": s_name = "Speed"; break;
                case "acc": s_name = "Accuracy"; break;
                case "eva": s_name = "Evasion"; break;
            }
            var rise = (_move.effect.amount > 0);
            result.message = s_name + (rise ? " rose!" : " fell!");
        } 
        // B) Condition Change
        else if (variable_struct_exists(_move.effect, "condition") && _move.effect.condition != "none") {
            result.condition_change = {
                condition: _move.effect.condition,
                target: _move.effect.target
            };
            if (_move.effect.condition == "PAR") result.message = "paralyzed!";
            if (_move.effect.condition == "BRN") result.message = "burned!";
            if (_move.effect.condition == "PSN") result.message = "poisoned!";
            if (_move.effect.condition == "SLP") result.message = "fell asleep!";
        }
        else {
            result.message = "But it failed!";
        }
        return result;
    }
    
    // 3. DAMAGE CALCULATION
    
    // Check for Fixed Damage (Seismic Toss / Night Shade)
    if (variable_struct_exists(_move.effect, "fixed") && _move.effect.fixed) {
        result.damage = _attacker.level;
        result.message = "It hit with fixed damage!";
    } 
    else {
        // Standard Formula
        var cat = get_gen3_category(_move.type);
        var a = (cat == "PHYSICAL") ? _attacker.stats.atk : _attacker.stats.spa;
        var d = (cat == "PHYSICAL") ? _defender.stats.def : _defender.stats.spd;
        
        // Burn Reduction (Physical only, unless Guts ability [not impl])
        if (_attacker.status_condition == "BRN" && cat == "PHYSICAL") a = floor(a * 0.5);
        
        var level_factor = (2 * _attacker.level) / 5 + 2;
        var base_dmg = (level_factor * _move.base_power * (a / d)) / 50 + 2;
        
        var multiplier = 1.0;
        
        // STAB
        if (array_contains(_attacker.types, _move.type)) multiplier *= 1.5;
        
        // Type Effectiveness
        var type_mult = 1.0;
        for (var i = 0; i < array_length(_defender.types); i++) {
            type_mult *= get_type_effectiveness(_move.type, _defender.types[i]);
        }
        multiplier *= type_mult;
        
        // Critical Hit (High Crit Logic)
        var crit_rate = 6.25;
        if (variable_struct_exists(_move.effect, "high_crit")) crit_rate = 12.5;
        
        var is_crit = (random(100) < crit_rate);
        if (is_crit) multiplier *= 2.0;
        
        var rng = irandom_range(85, 100) / 100;
        result.damage = floor(base_dmg * multiplier * rng);
        if (result.damage < 1 && type_mult > 0) result.damage = 1;
        
        // Messages
        if (type_mult == 0) result.message = "It had no effect...";
        else if (type_mult > 1) result.message = "It's super effective!";
        else if (type_mult < 1) result.message = "It's not very effective...";
        
        if (is_crit && type_mult > 0) result.message += " Critical hit!";
    }
    
    // 4. COMPLEX EFFECTS (Drain & Recoil)
    if (result.damage > 0) {
        // DRAIN (Giga Drain)
        if (variable_struct_exists(_move.effect, "drain")) {
            result.heal = floor(result.damage * _move.effect.drain);
            result.message += " Drained health!";
        }
        // RECOIL (Double Edge)
        if (variable_struct_exists(_move.effect, "recoil")) {
            result.recoil = floor(result.damage * _move.effect.recoil);
            result.message += " Hit with recoil!";
        }
    }
    
    // 5. SECONDARY EFFECTS (10%, 30% chances etc)
    if (irandom(100) < _move.effect.chance) {
        
        // Secondary Stat Change
        if (variable_struct_exists(_move.effect, "stat") && _move.effect.stat != "none") {
            result.stat_change = {
                stat: _move.effect.stat,
                stages: _move.effect.amount,
                target: _move.effect.target
            };
            
            var s_name = _move.effect.stat; 
            // Reuse switch from above or make helper function
            var rise = (_move.effect.amount > 0);
            result.message += " Stat" + (rise ? " rose!" : " fell!");
        }
        
        // Secondary Condition Change
        if (variable_struct_exists(_move.effect, "condition") && _move.effect.condition != "none") {
            result.condition_change = {
                condition: _move.effect.condition,
                target: _move.effect.target
            };

            switch (_move.effect.condition) {
                case "PAR": result.message += " The foe was paralyzed!"; break;
                case "BRN": result.message += " The foe was burned!"; break;
                case "PSN": result.message += " The foe was poisoned!"; break;
                case "SLP": result.message += " The foe fell asleep!"; break;
                case "CNF": result.message += " The foe became confused!"; break;
            }
        }
    }

    return result;
}

function array_contains(_arr, _val) {
    for(var i=0; i<array_length(_arr); i++) {
        if (_arr[i] == _val) return true;
    }
    return false;
}


