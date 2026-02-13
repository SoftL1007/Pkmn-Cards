/// @desc scr_definitions
/// Defines the blueprints (Structs) and Enums. No specific data here.

enum ELEMENT {
    NORMAL, FIRE, WATER, GRASS, ELECTRIC, ICE, FIGHTING, POISON, GROUND,
    FLYING, PSYCHIC, BUG, ROCK, GHOST, DRAGON, STEEL, DARK, NONE
}

enum BATTLE_STATE {
    START,          // Initialize
    DRAW_PHASE,     // Get cards
    INPUT_PHASE,    // Player chooses Move + Card
    RESOLVE_PHASE,  // Calculate order
    CHECK_FAINT,    // See who died
    WIN_LOSS,       // End
    WAIT            // Animation delay
}

enum ACTION_TYPE {
    CARD,
    SWITCH,
    ATTACK
}

enum SCOPE {
    SELF,
    ENEMY
}

/// @func Move(_id, _name, _type, _bp, _acc, _cat, _prio)
function Move(_id, _name, _type, _bp, _acc, _cat, _prio) constructor {
    id = _id;
    name = _name;
    type = _type;
    base_power = _bp; 
    accuracy = _acc;
    category = _cat; // "PHYSICAL", "SPECIAL", "STATUS"
    priority = _prio;
    pp = 10;
}

/// @func Pokemon(_species_data, _level, _moves)
function Pokemon(_species_data, _level, _moves) constructor {
    species_name = _species_data.name;
    nickname = species_name; // <--- FIXED: Added this variable back
    types = _species_data.types; 
    level = _level;
    
    // Gen 3 Stats
    max_hp = floor((2 * _species_data.hp * level) / 100 + level + 10);
    current_hp = max_hp;
    
    stats = {
        atk: floor((2 * _species_data.atk * level) / 100 + 5),
        def: floor((2 * _species_data.def * level) / 100 + 5),
        spa: floor((2 * _species_data.spa * level) / 100 + 5),
        spd: floor((2 * _species_data.spd * level) / 100 + 5),
        spe: floor((2 * _species_data.spe * level) / 100 + 5)
    };
    
    stat_stages = { atk: 0, def: 0, spa: 0, spd: 0, spe: 0, acc: 0, eva: 0 };
    moves = _moves;
    status = "NONE";
}

/// @func BattleCard(_id, _name, _desc, _scope)
function BattleCard(_id, _name, _desc, _scope) constructor {
    id = _id;
    name = _name;
    description = _desc;
    target_scope = _scope; 
}