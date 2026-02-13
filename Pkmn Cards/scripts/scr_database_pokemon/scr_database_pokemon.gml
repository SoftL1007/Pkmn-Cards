/// @func get_pokemon_species(_species_id)
/// @desc Database of Base Stats (Gen 3 accurate) & Competitive Movesets
function get_pokemon_species(_species_id) {
    
    // Default Fallback
    var def = { 
        name: "MissingNo", sprite_index: 0, 
        types: [ELEMENT.NORMAL], 
        hp: 33, atk: 136, def: 0, spa: 6, spd: 6, spe: 29, 
        move_ids: ["water_gun", "water_gun", "sky_attack", "sky_attack"] 
    };

    switch (_species_id) {

        // ======================
        // KANTO (1–12)
        // ======================

        case "charizard":
            return { name:"Charizard", sprite_index:1,
                types:[ELEMENT.FIRE, ELEMENT.FLYING],
                hp:78, atk:84, def:78, spa:109, spd:85, spe:100,
                move_ids: ["flamethrower", "wing_attack", "dragon_claw", "swords_dance"] };

        case "blastoise":
            return { name:"Blastoise", sprite_index:2,
                types:[ELEMENT.WATER],
                hp:79, atk:83, def:100, spa:85, spd:105, spe:78,
                move_ids: ["surf", "ice_beam", "toxic", "earthquake"] };

        case "venusaur":
            return { name:"Venusaur", sprite_index:3,
                types:[ELEMENT.GRASS, ELEMENT.POISON],
                hp:80, atk:82, def:83, spa:100, spd:100, spe:80,
                move_ids: ["giga_drain", "sludge", "sleep_powder", "swords_dance"] };

        case "alakazam":
            return { name:"Alakazam", sprite_index:4,
                types:[ELEMENT.PSYCHIC],
                hp:55, atk:50, def:45, spa:135, spd:95, spe:120,
                move_ids: ["psychic", "ice_punch", "thunder_punch", "calm_mind"] };

        case "gengar":
            return { name:"Gengar", sprite_index:5,
                types:[ELEMENT.GHOST, ELEMENT.POISON],
                hp:60, atk:65, def:60, spa:130, spd:75, spe:110,
                move_ids: ["thunderbolt", "ice_punch", "psychic", "hypnosis"] };

        case "gyarados":
            return { name:"Gyarados", sprite_index:6,
                types:[ELEMENT.WATER, ELEMENT.FLYING],
                hp:95, atk:125, def:79, spa:60, spd:100, spe:81,
                move_ids: ["dragon_dance", "earthquake", "return", "hydro_pump"] };

        case "snorlax":
            return { name:"Snorlax", sprite_index:7,
                types:[ELEMENT.NORMAL],
                hp:160, atk:110, def:65, spa:65, spd:110, spe:30,
                move_ids: ["body_slam", "shadow_ball", "earthquake", "brick_break"] };

        case "machamp":
            return { name:"Machamp", sprite_index:8,
                types:[ELEMENT.FIGHTING],
                hp:90, atk:130, def:80, spa:65, spd:85, spe:55,
                move_ids: ["cross_chop", "rock_slide", "earthquake", "bulk_up"] };

        case "rhydon":
            return { name:"Rhydon", sprite_index:9,
                types:[ELEMENT.GROUND, ELEMENT.ROCK],
                hp:105, atk:130, def:120, spa:45, spd:45, spe:40,
                move_ids: ["earthquake", "rock_slide", "brick_break", "swords_dance"] };

        case "jolteon":
            return { name:"Jolteon", sprite_index:10,
                types:[ELEMENT.ELECTRIC],
                hp:65, atk:65, def:60, spa:110, spd:95, spe:130,
                move_ids: ["thunderbolt", "thunder_wave", "body_slam", "quick_attack"] };

        case "dragonite":
            return { name:"Dragonite", sprite_index:11,
                types:[ELEMENT.DRAGON, ELEMENT.FLYING],
                hp:91, atk:134, def:95, spa:100, spd:100, spe:80,
                move_ids: ["dragon_dance", "aerial_ace", "earthquake", "thunderbolt"] };

        case "arcanine":
            return { name:"Arcanine", sprite_index:12,
                types:[ELEMENT.FIRE],
                hp:90, atk:110, def:80, spa:100, spd:80, spe:95,
                move_ids: ["flamethrower", "body_slam", "iron_tail", "howl"] };

        // ======================
        // JOHTO (13–24)
        // ======================

        case "typhlosion":
            return { name:"Typhlosion", sprite_index:13,
                types:[ELEMENT.FIRE],
                hp:78, atk:84, def:78, spa:109, spd:85, spe:100,
                move_ids: ["flamethrower", "thunder_punch", "earthquake", "quick_attack"] };

        case "feraligatr":
            return { name:"Feraligatr", sprite_index:14,
                types:[ELEMENT.WATER],
                hp:85, atk:105, def:100, spa:79, spd:83, spe:78,
                move_ids: ["swords_dance", "earthquake", "rock_slide", "brick_break"] };

        case "meganium":
            return { name:"Meganium", sprite_index:15,
                types:[ELEMENT.GRASS],
                hp:80, atk:82, def:100, spa:83, spd:100, spe:80,
                move_ids: ["giga_drain", "toxic", "body_slam", "earthquake"] };

        case "tyranitar":
            return { name:"Tyranitar", sprite_index:16,
                types:[ELEMENT.ROCK, ELEMENT.DARK],
                hp:100, atk:134, def:110, spa:95, spd:100, spe:61,
                move_ids: ["dragon_dance", "rock_slide", "earthquake", "crunch"] };

        case "scizor":
            return { name:"Scizor", sprite_index:17,
                types:[ELEMENT.BUG, ELEMENT.STEEL],
                hp:70, atk:130, def:100, spa:55, spd:80, spe:65,
                move_ids: ["swords_dance", "steel_wing", "silver_wind", "quick_attack"] };

        case "heracross":
            return { name:"Heracross", sprite_index:18,
                types:[ELEMENT.BUG, ELEMENT.FIGHTING],
                hp:80, atk:125, def:75, spa:40, spd:95, spe:85,
                move_ids: ["brick_break", "rock_slide", "earthquake", "swords_dance"] };

        case "houndoom":
            return { name:"Houndoom", sprite_index:19,
                types:[ELEMENT.DARK, ELEMENT.FIRE],
                hp:75, atk:90, def:50, spa:110, spd:80, spe:95,
                move_ids: ["crunch", "flamethrower", "pursuit", "will_o_wisp"] };

        case "kingdra":
            return { name:"Kingdra", sprite_index:20,
                types:[ELEMENT.WATER, ELEMENT.DRAGON],
                hp:75, atk:95, def:95, spa:95, spd:95, spe:85,
                move_ids: ["surf", "ice_beam", "dragon_breath", "toxic"] };

        case "skarmory":
            return { name:"Skarmory", sprite_index:21,
                types:[ELEMENT.STEEL, ELEMENT.FLYING],
                hp:65, atk:80, def:140, spa:40, spd:70, spe:70,
                move_ids: ["steel_wing", "aerial_ace", "toxic", "spikes"] };

        case "umbreon":
            return { name:"Umbreon", sprite_index:22,
                types:[ELEMENT.DARK],
                hp:95, atk:65, def:110, spa:60, spd:130, spe:65,
                move_ids: ["pursuit", "toxic", "quick_attack", "confuse_ray"] };

        case "espeon":
            return { name:"Espeon", sprite_index:23,
                types:[ELEMENT.PSYCHIC],
                hp:65, atk:65, def:60, spa:130, spd:95, spe:110,
                move_ids: ["psychic", "calm_mind", "psybeam", "quick_attack"] };

        case "donphan":
            return { name:"Donphan", sprite_index:24,
                types:[ELEMENT.GROUND],
                hp:90, atk:120, def:120, spa:60, spd:60, spe:50,
                move_ids: ["earthquake", "rock_slide", "rollout", "body_slam"] };

        // ======================
        // HOENN (25–36)
        // ======================

        case "blaziken":
            return { name:"Blaziken", sprite_index:25,
                types:[ELEMENT.FIRE, ELEMENT.FIGHTING],
                hp:80, atk:120, def:70, spa:110, spd:70, spe:80,
                move_ids: ["sky_uppercut", "blaze_kick", "rock_slide", "bulk_up"] };

        case "swampert":
            return { name:"Swampert", sprite_index:26,
                types:[ELEMENT.WATER, ELEMENT.GROUND],
                hp:100, atk:110, def:90, spa:85, spd:90, spe:60,
                move_ids: ["earthquake", "surf", "ice_beam", "rock_slide"] };

        case "sceptile":
            return { name:"Sceptile", sprite_index:27,
                types:[ELEMENT.GRASS],
                hp:70, atk:85, def:65, spa:105, spd:85, spe:120,
                move_ids: ["leaf_blade", "dragon_claw", "thunder_punch", "crunch"] };

        case "gardevoir":
            return { name:"Gardevoir", sprite_index:28,
                types:[ELEMENT.PSYCHIC],
                hp:68, atk:65, def:65, spa:125, spd:115, spe:80,
                move_ids: ["psychic", "thunderbolt", "calm_mind", "hypnosis"] };

        case "metagross":
            return { name:"Metagross", sprite_index:29,
                types:[ELEMENT.STEEL, ELEMENT.PSYCHIC],
                hp:80, atk:135, def:130, spa:95, spd:90, spe:70,
                move_ids: ["earthquake", "shadow_ball", "brick_break", "aerial_ace"] };

        case "salamence":
            return { name:"Salamence", sprite_index:30,
                types:[ELEMENT.DRAGON, ELEMENT.FLYING],
                hp:95, atk:135, def:80, spa:110, spd:80, spe:100,
                move_ids: ["dragon_dance", "earthquake", "aerial_ace", "dragon_claw"] };

        case "milotic":
            return { name:"Milotic", sprite_index:31,
                types:[ELEMENT.WATER],
                hp:95, atk:60, def:79, spa:100, spd:125, spe:81,
                move_ids: ["surf", "ice_beam", "toxic", "hypnosis"] };

        case "aggron":
            return { name:"Aggron", sprite_index:32,
                types:[ELEMENT.STEEL, ELEMENT.ROCK],
                hp:70, atk:110, def:180, spa:60, spd:60, spe:50,
                move_ids: ["iron_tail", "earthquake", "rock_slide", "double_edge"] };

        case "flygon":
            return { name:"Flygon", sprite_index:33,
                types:[ELEMENT.GROUND, ELEMENT.DRAGON],
                hp:80, atk:100, def:80, spa:80, spd:80, spe:100,
                move_ids: ["earthquake", "rock_slide", "dragon_claw", "flamethrower"] };

        case "manectric":
            return { name:"Manectric", sprite_index:34,
                types:[ELEMENT.ELECTRIC],
                hp:70, atk:75, def:60, spa:105, spd:60, spe:105,
                move_ids: ["thunderbolt", "crunch", "thunder_wave", "bite"] };

        case "tropius":
            return { name:"Tropius", sprite_index:35,
                types:[ELEMENT.GRASS, ELEMENT.FLYING],
                hp:99, atk:68, def:83, spa:72, spd:87, spe:51,
                move_ids: ["solar_beam", "aerial_ace", "earthquake", "synthesis"] };

        case "dusclops":
            return { name:"Dusclops", sprite_index:36,
                types:[ELEMENT.GHOST],
                hp:40, atk:70, def:130, spa:60, spd:130, spe:25,
                move_ids: ["shadow_ball", "will_o_wisp", "ice_beam", "seismic_toss"] };

        default:
            show_debug_message("ERROR: Pokemon " + string(_species_id) + " not found.");
            return def;
    }
}