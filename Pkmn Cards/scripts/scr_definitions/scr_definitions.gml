/// @desc scr_definitions
enum ELEMENT {
    NORMAL, FIRE, WATER, GRASS, ELECTRIC, ICE, FIGHTING, POISON, GROUND,
    FLYING, PSYCHIC, BUG, ROCK, GHOST, DRAGON, STEEL, DARK, NONE
}

enum BATTLE_STATE {
    START,          
    DRAW_PHASE,     
    INPUT_PHASE,    
    RESOLVE_PHASE,  
    CHECK_FAINT,    // New: Check if active mon died
    FORCE_SWITCH,   // New: Player must pick replacement
    WIN_LOSS,       
    WAIT            
}

enum ACTION_TYPE {
    CARD,
    SWITCH, // New: Switching action
    ATTACK
}

enum SCOPE { SELF, ENEMY }

/// @func Move(_id, _name, _type, _bp, _acc, _prio)
/// @desc Note: Category (Phys/Spec) is determined by TYPE in Gen 3, not per move.
function Move(_id, _name, _type, _bp, _acc, _prio) constructor {
    id = _id;
    name = _name;
    type = _type;
    base_power = _bp; 
    accuracy = _acc;
    priority = _prio;
    pp = 10;
    max_pp = 10;
}

/// @func Pokemon(_species_data, _level, _moves_array)
function Pokemon(_species_data, _level, _moves) constructor {
    // SAFETY CHECK: If the database returned 'undefined' or a bad struct
    if (is_undefined(_species_data)) {
        show_error("CRITICAL ERROR: Species Data is undefined. Check spelling in obj_battle_manager.", true);
    }

    species_name = _species_data.name;
    nickname = species_name; 
    sprite_frame = _species_data.sprite_index; 
    types = _species_data.types; 
    level = _level;

    // Gen 3 Stat Formula
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
    
    static is_fainted = function() {
        return current_hp <= 0;
    }
}

/// @func BattleCard(_id, _name, _desc, _scope)
function BattleCard(_id, _name, _desc, _scope) constructor {
    id = _id;
    name = _name;
    description = _desc;
    target_scope = _scope; 
}