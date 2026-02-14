/// @desc scr_definitions
enum ELEMENT {
    NORMAL, FIRE, WATER, GRASS, ELECTRIC, ICE, FIGHTING, POISON, GROUND,
    FLYING, PSYCHIC, BUG, ROCK, GHOST, DRAGON, STEEL, DARK, NONE
}

enum BATTLE_STATE {
    START,
    TURN_START_DECISION, 
    DISCARD_CHOICE,      
    INPUT_PHASE,         
    SWITCH_MENU,
    REVIVE_MENU,        
    RESOLVE_PHASE,
    ANIMATION_WAIT,
    ANIMATION_SWITCH, // <--- This was missing!
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

function Move(_id, _name, _type, _bp, _acc, _prio, _effect = undefined) constructor {
    id = _id;
    name = _name;
    type = _type;
    base_power = _bp; 
    accuracy = _acc;
    priority = _prio;
    pp = 10;
    max_pp = 10;
    
    if (_effect == undefined) {
        effect = { chance: 0, target: SCOPE.ENEMY, stat: "none", condition: "none", amount: 0 };
    } else {
        effect = _effect;
        if (!variable_struct_exists(effect, "condition")) effect.condition = "none";
        if (!variable_struct_exists(effect, "stat")) effect.stat = "none";
    }
}

/// @desc scr_definitions

enum CARD_TYPE { MAGIC, TRAP, EVENT } // Event = Heals/Special that appear randomly
enum RARITY { COMMON, RARE, EPIC, LEGENDARY }

function BattleCard(_id, _name, _desc, _scope, _type, _rarity, _icon_idx, _effect_data = undefined) constructor {
    id = _id;
    name = _name;
    description = _desc;
    target_scope = _scope; 
    type = _type;
    rarity = _rarity;
    icon_index = _icon_idx; // The frame number in spr_cards
    effect_data = _effect_data; // Struct for specific logic (e.g. trap trigger)
}

// Update Pokemon Struct to hold a Trap Slot AND Helper for Stats
function Pokemon(_species_data, _level, _moves) constructor {
    species_name = _species_data.name;
    nickname = species_name; 
    sprite_frame = _species_data.sprite_index; 
    types = _species_data.types; 
    level = _level;
    max_hp = floor((2 * _species_data.hp * level) / 100 + level + 10);
    current_hp = max_hp;
    
    // *** FIX: This ensures the UI never crashes trying to read the health bar ***
    display_hp = current_hp; 
    
    base_stats = {
        atk: floor((2 * _species_data.atk * level) / 100 + 5),
        def: floor((2 * _species_data.def * level) / 100 + 5),
        spa: floor((2 * _species_data.spa * level) / 100 + 5),
        spd: floor((2 * _species_data.spd * level) / 100 + 5),
        spe: floor((2 * _species_data.spe * level) / 100 + 5)
    };
    
    stats = { atk:0, def:0, spa:0, spd:0, spe:0 };
    stat_stages = { atk: 0, def: 0, spa: 0, spd: 0, spe: 0, acc: 0, eva: 0 };
    card_buffs = { atk: 1.0, def: 1.0, spa: 1.0, spd: 1.0, spe: 1.0 };
    
    status_condition = "NONE";
    status_turn = 0;
    
    moves = _moves; 
    active_trap = undefined; 
    
    static is_fainted = function() { return current_hp <= 0; }
    
    static recalculate_stats = function() {
        var stat_keys = ["atk", "def", "spa", "spd", "spe"];
        for (var i = 0; i < array_length(stat_keys); i++) {
            var key = stat_keys[i];
            var stage = variable_struct_get(stat_stages, key);
            var base = variable_struct_get(base_stats, key);
            var card_mult = variable_struct_get(card_buffs, key);
            var stage_mult = (stage >= 0) ? (2 + stage) / 2 : 2 / (2 + abs(stage));
            var status_mult = 1.0;
            if (status_condition == "BRN" && key == "atk") status_mult = 0.5;
            if (status_condition == "PAR" && key == "spe") status_mult = 0.25;
            variable_struct_set(stats, key, floor(base * stage_mult * card_mult * status_mult));
        }
    }
    recalculate_stats();
    
    static modify_stage = function(_stat, _amount) {
        if (!variable_struct_exists(stat_stages, _stat)) return;
        var current = variable_struct_get(stat_stages, _stat);
        current += _amount;
        if (current > 6) current = 6;
        if (current < -6) current = -6;
        variable_struct_set(stat_stages, _stat, current);
        recalculate_stats(); 
    }
    
    static has_any_buff = function() {
        var keys = ["atk", "def", "spa", "spd", "spe"];
        for(var i=0; i<5; i++) {
            if (variable_struct_get(stat_stages, keys[i]) > 0) return true;
            if (variable_struct_get(card_buffs, keys[i]) > 1.0) return true;
        }
        return false;
    }
    
    static has_any_debuff = function() {
        var keys = ["atk", "def", "spa", "spd", "spe"];
        for(var i=0; i<5; i++) {
            if (variable_struct_get(stat_stages, keys[i]) < 0) return true;
        }
        if (status_condition != "NONE") return true; 
        return false;
    }
}

// --- NETWORK PACKET HEADERS ---
enum NETWORK_MSG {
    HANDSHAKE,      // "Hello, I am here."
    TEAM_DATA,      // "Here is my team of 6 Pokemon."
    START_GAME,     // "Both teams are ready, let's fight!"
    SUBMIT_ACTION,  // "I chose to use Flamethrower."
    SYNC_TURN,      // "Here is what happened this turn (Damage, Crits, etc)."
    REMATCH,        // "Let's play again."
    DISCONNECT      // "I rage quit."
}