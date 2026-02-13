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
    CHECK_FAINT,    
    WIN_LOSS,       
    WAIT            
}

enum ACTION_TYPE {
    CARD,
    SWITCH, 
    ATTACK
}

enum SCOPE { SELF, ENEMY }

/// @func Move(_id, _name, _type, _bp, _acc, _prio)
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

/// @func BattleCard(_id, _name, _desc, _scope)
function BattleCard(_id, _name, _desc, _scope) constructor {
    id = _id;
    name = _name;
    description = _desc;
    target_scope = _scope; 
}

/// @func Pokemon(_species_data, _level, _moves)
function Pokemon(_species_data, _level, _moves) constructor {
    species_name = _species_data.name;
    nickname = species_name; 
    sprite_frame = _species_data.sprite_index; 
    types = _species_data.types; 
    level = _level;

    // Gen 3 Stat Formula
    max_hp = floor((2 * _species_data.hp * level) / 100 + level + 10);
    current_hp = max_hp;
    
    // Base Stats (Immutable)
    base_stats = {
        atk: floor((2 * _species_data.atk * level) / 100 + 5),
        def: floor((2 * _species_data.def * level) / 100 + 5),
        spa: floor((2 * _species_data.spa * level) / 100 + 5),
        spd: floor((2 * _species_data.spd * level) / 100 + 5),
        spe: floor((2 * _species_data.spe * level) / 100 + 5)
    };
    
    // Current Active Stats (Mutable)
    stats = { atk:0, def:0, spa:0, spd:0, spe:0 };
    
    // Stages: -6 to +6 (Permanent until switch)
    stat_stages = { atk: 0, def: 0, spa: 0, spd: 0, spe: 0, acc: 0, eva: 0 };
    
    // Card Buffs: 1.0 or 1.5 (Temporary 1 Turn)
    card_buffs = { atk: 1.0, def: 1.0, spa: 1.0, spd: 1.0, spe: 1.0 };

    moves = _moves; 
    status = "NONE";
    
    static is_fainted = function() {
        return current_hp <= 0;
    }
    
    // Function to Recalculate Stats based on Stages + Cards
    static recalculate_stats = function() {
        var stat_keys = ["atk", "def", "spa", "spd", "spe"];
        
        for (var i = 0; i < array_length(stat_keys); i++) {
            var key = stat_keys[i];
            var stage = variable_struct_get(stat_stages, key);
            var base = variable_struct_get(base_stats, key);
            var card_mult = variable_struct_get(card_buffs, key);
            
            // Gen 3 Stage Multiplier
            var stage_mult = 1.0;
            if (stage >= 0) stage_mult = (2 + stage) / 2;
            else stage_mult = 2 / (2 + abs(stage));
            
            // Final Calculation
            variable_struct_set(stats, key, floor(base * stage_mult * card_mult));
        }
    }
    
    // Initialize stats immediately
    recalculate_stats();
}