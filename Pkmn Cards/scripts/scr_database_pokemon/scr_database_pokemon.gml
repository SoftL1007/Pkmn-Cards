/// @func get_pokemon_species(_species_id)
function get_pokemon_species(_species_id) {
    
    // Fallback
    var def = { name: "MissingNo", sprite_index: 0, types: [ELEMENT.NORMAL], hp: 50, atk: 50, def: 50, spa: 50, spd: 50, spe: 50, move_ids: ["tackle"] };

    switch (_species_id) {

        // GEN 1
        case "charizard": return { name:"Charizard", sprite_index:1, types:[ELEMENT.FIRE, ELEMENT.FLYING],
            hp:78, atk:84, def:78, spa:109, spd:85, spe:100,
            move_ids: ["fire_blast", "earthquake", "aerial_ace", "dragon_dance"] };

        case "blastoise": return { name:"Blastoise", sprite_index:2, types:[ELEMENT.WATER],
            hp:79, atk:83, def:100, spa:85, spd:105, spe:78,
            move_ids: ["surf", "ice_beam", "toxic", "earthquake"] };

        case "venusaur": return { name:"Venusaur", sprite_index:3, types:[ELEMENT.GRASS, ELEMENT.POISON],
            hp:80, atk:82, def:83, spa:100, spd:100, spe:80,
            move_ids: ["giga_drain", "sludge_bomb", "sleep_powder", "synthesis"] };

        case "alakazam": return { name:"Alakazam", sprite_index:4, types:[ELEMENT.PSYCHIC],
            hp:55, atk:50, def:45, spa:135, spd:95, spe:120,
            move_ids: ["psychic", "fire_punch", "thunder_punch", "calm_mind"] }; // Ele-Punches were Special in Gen 3

        case "gengar": return { name:"Gengar", sprite_index:5, types:[ELEMENT.GHOST, ELEMENT.POISON],
            hp:60, atk:65, def:60, spa:130, spd:75, spe:110,
            move_ids: ["thunderbolt", "ice_punch", "giga_drain", "psychic"] };

        case "gyarados": return { name:"Gyarados", sprite_index:6, types:[ELEMENT.WATER, ELEMENT.FLYING],
            hp:95, atk:125, def:79, spa:60, spd:100, spe:81,
            move_ids: ["dragon_dance", "earthquake", "return", "hydro_pump"] };

        case "snorlax": return { name:"Snorlax", sprite_index:7, types:[ELEMENT.NORMAL],
            hp:160, atk:110, def:65, spa:65, spd:110, spe:30,
            move_ids: ["body_slam", "shadow_ball", "earthquake", "brick_break"] };

        case "machamp": return { name:"Machamp", sprite_index:8, types:[ELEMENT.FIGHTING],
            hp:90, atk:130, def:80, spa:65, spd:85, spe:55,
            move_ids: ["cross_chop", "rock_slide", "earthquake", "bulk_up"] };

        case "rhydon": return { name:"Rhydon", sprite_index:9, types:[ELEMENT.GROUND, ELEMENT.ROCK],
            hp:105, atk:130, def:120, spa:45, spd:45, spe:40,
            move_ids: ["earthquake", "rock_slide", "megahorn", "swords_dance"] };

        case "jolteon": return { name:"Jolteon", sprite_index:10, types:[ELEMENT.ELECTRIC],
            hp:65, atk:65, def:60, spa:110, spd:95, spe:130,
            move_ids: ["thunderbolt", "bite", "double_kick", "thunder_wave"] };

        case "dragonite": return { name:"Dragonite", sprite_index:11, types:[ELEMENT.DRAGON, ELEMENT.FLYING],
            hp:91, atk:134, def:95, spa:100, spd:100, spe:80,
            move_ids: ["dragon_dance", "aerial_ace", "earthquake", "thunderbolt"] };

        case "arcanine": return { name:"Arcanine", sprite_index:12, types:[ELEMENT.FIRE],
            hp:90, atk:110, def:80, spa:100, spd:80, spe:95,
            move_ids: ["flamethrower", "extremespeed", "iron_tail", "howl"] }; // E-Speed manual

        // GEN 2
        case "typhlosion": return { name:"Typhlosion", sprite_index:13, types:[ELEMENT.FIRE],
            hp:78, atk:84, def:78, spa:109, spd:85, spe:100,
            move_ids: ["flamethrower", "thunder_punch", "earthquake", "quick_attack"] };

        case "feraligatr": return { name:"Feraligatr", sprite_index:14, types:[ELEMENT.WATER],
            hp:85, atk:105, def:100, spa:79, spd:83, spe:78,
            move_ids: ["swords_dance", "earthquake", "rock_slide", "hydro_pump"] };

        case "meganium": return { name:"Meganium", sprite_index:15, types:[ELEMENT.GRASS],
            hp:80, atk:82, def:100, spa:83, spd:100, spe:80,
            move_ids: ["giga_drain", "toxic", "synthesis", "earthquake"] };

        case "tyranitar": return { name:"Tyranitar", sprite_index:16, types:[ELEMENT.ROCK, ELEMENT.DARK],
            hp:100, atk:134, def:110, spa:95, spd:100, spe:61,
            move_ids: ["dragon_dance", "rock_slide", "earthquake", "crunch"] };

        case "scizor": return { name:"Scizor", sprite_index:17, types:[ELEMENT.BUG, ELEMENT.STEEL],
            hp:70, atk:130, def:100, spa:55, spd:80, spe:65,
            move_ids: ["swords_dance", "steel_wing", "silver_wind", "quick_attack"] };

        case "heracross": return { name:"Heracross", sprite_index:18, types:[ELEMENT.BUG, ELEMENT.FIGHTING],
            hp:80, atk:125, def:75, spa:40, spd:95, spe:85,
            move_ids: ["megahorn", "brick_break", "rock_slide", "swords_dance"] };

        case "houndoom": return { name:"Houndoom", sprite_index:19, types:[ELEMENT.DARK, ELEMENT.FIRE],
            hp:75, atk:90, def:50, spa:110, spd:80, spe:95,
            move_ids: ["crunch", "flamethrower", "pursuit", "will_o_wisp"] };

        case "kingdra": return { name:"Kingdra", sprite_index:20, types:[ELEMENT.WATER, ELEMENT.DRAGON],
            hp:75, atk:95, def:95, spa:95, spd:95, spe:85,
            move_ids: ["hydro_pump", "ice_beam", "dragon_breath", "toxic"] };

        case "skarmory": return { name:"Skarmory", sprite_index:21, types:[ELEMENT.STEEL, ELEMENT.FLYING],
            hp:65, atk:80, def:140, spa:40, spd:70, spe:70,
            move_ids: ["steel_wing", "drill_peck", "toxic", "spikes"] };

        case "umbreon": return { name:"Umbreon", sprite_index:22, types:[ELEMENT.DARK],
            hp:95, atk:65, def:110, spa:60, spd:130, spe:65,
            move_ids: ["pursuit", "toxic", "moonlight", "confuse_ray"] }; // Moonlight manual or generic

        case "espeon": return { name:"Espeon", sprite_index:23, types:[ELEMENT.PSYCHIC],
            hp:65, atk:65, def:60, spa:130, spd:95, spe:110,
            move_ids: ["psychic", "calm_mind", "bite", "morning_sun"] };

        case "donphan": return { name:"Donphan", sprite_index:24, types:[ELEMENT.GROUND],
            hp:90, atk:120, def:120, spa:60, spd:60, spe:50,
            move_ids: ["earthquake", "rock_slide", "rapid_spin", "body_slam"] };

        // GEN 3
        case "blaziken": return { name:"Blaziken", sprite_index:25, types:[ELEMENT.FIRE, ELEMENT.FIGHTING],
            hp:80, atk:120, def:70, spa:110, spd:70, spe:80,
            move_ids: ["sky_uppercut", "overheat", "rock_slide", "bulk_up"] };

        case "swampert": return { name:"Swampert", sprite_index:26, types:[ELEMENT.WATER, ELEMENT.GROUND],
            hp:100, atk:110, def:90, spa:85, spd:90, spe:60,
            move_ids: ["earthquake", "surf", "ice_beam", "protect"] };

        case "sceptile": return { name:"Sceptile", sprite_index:27, types:[ELEMENT.GRASS],
            hp:70, atk:85, def:65, spa:105, spd:85, spe:120,
            move_ids: ["leaf_blade", "dragon_claw", "thunder_punch", "crunch"] };

        case "gardevoir": return { name:"Gardevoir", sprite_index:28, types:[ELEMENT.PSYCHIC],
            hp:68, atk:65, def:65, spa:125, spd:115, spe:80,
            move_ids: ["psychic", "thunderbolt", "calm_mind", "will_o_wisp"] };

        case "metagross": return { name:"Metagross", sprite_index:29, types:[ELEMENT.STEEL, ELEMENT.PSYCHIC],
            hp:80, atk:135, def:130, spa:95, spd:90, spe:70,
            move_ids: ["meteor_mash", "earthquake", "explosion", "agility"] };

        case "salamence": return { name:"Salamence", sprite_index:30, types:[ELEMENT.DRAGON, ELEMENT.FLYING],
            hp:95, atk:135, def:80, spa:110, spd:80, spe:100,
            move_ids: ["dragon_dance", "earthquake", "aerial_ace", "brick_break"] };

        case "milotic": return { name:"Milotic", sprite_index:31, types:[ELEMENT.WATER],
            hp:95, atk:60, def:79, spa:100, spd:125, spe:81,
            move_ids: ["surf", "ice_beam", "toxic", "recover"] };

        case "aggron": return { name:"Aggron", sprite_index:32, types:[ELEMENT.STEEL, ELEMENT.ROCK],
            hp:70, atk:110, def:180, spa:60, spd:60, spe:50,
            move_ids: ["iron_tail", "earthquake", "rock_slide", "double_edge"] };

        case "flygon": return { name:"Flygon", sprite_index:33, types:[ELEMENT.GROUND, ELEMENT.DRAGON],
            hp:80, atk:100, def:80, spa:80, spd:80, spe:100,
            move_ids: ["earthquake", "rock_slide", "fire_blast", "quick_attack"] };

        case "manectric": return { name:"Manectric", sprite_index:34, types:[ELEMENT.ELECTRIC],
            hp:70, atk:75, def:60, spa:105, spd:60, spe:105,
            move_ids: ["thunderbolt", "crunch", "thunder_wave", "bite"] };

        case "tropius": return { name:"Tropius", sprite_index:35, types:[ELEMENT.GRASS, ELEMENT.FLYING],
            hp:99, atk:68, def:83, spa:72, spd:87, spe:51,
            move_ids: ["solar_beam", "aerial_ace", "earthquake", "synthesis"] };

        case "dusclops": return { name:"Dusclops", sprite_index:36, types:[ELEMENT.GHOST],
            hp:40, atk:70, def:130, spa:60, spd:130, spe:25,
            move_ids: ["shadow_ball", "will_o_wisp", "ice_beam", "seismic_toss"] };

        default:
            show_debug_message("ERROR: Pokemon " + string(_species_id) + " not found.");
            return def;
    }
}