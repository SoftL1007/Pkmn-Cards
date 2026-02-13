/// @func get_pokemon_species(_species_id)
/// @desc Database of Base Stats (Gen 3 accurate)
function get_pokemon_species(_species_id) {
    switch (_species_id) {

        // ======================
        // KANTO (1–12)
        // ======================

        case "charizard":
            return { name:"Charizard", sprite_index:1,
                types:[ELEMENT.FIRE, ELEMENT.FLYING],
                hp:78, atk:84, def:78, spa:109, spd:85, spe:100 };

        case "blastoise":
            return { name:"Blastoise", sprite_index:2,
                types:[ELEMENT.WATER],
                hp:79, atk:83, def:100, spa:85, spd:105, spe:78 };

        case "venusaur":
            return { name:"Venusaur", sprite_index:3,
                types:[ELEMENT.GRASS, ELEMENT.POISON],
                hp:80, atk:82, def:83, spa:100, spd:100, spe:80 };

        case "alakazam":
            return { name:"Alakazam", sprite_index:4,
                types:[ELEMENT.PSYCHIC],
                hp:55, atk:50, def:45, spa:135, spd:95, spe:120 };

        case "gengar":
            return { name:"Gengar", sprite_index:5,
                types:[ELEMENT.GHOST, ELEMENT.POISON],
                hp:60, atk:65, def:60, spa:130, spd:75, spe:110 };

        case "gyarados":
            return { name:"Gyarados", sprite_index:6,
                types:[ELEMENT.WATER, ELEMENT.FLYING],
                hp:95, atk:125, def:79, spa:60, spd:100, spe:81 };

        case "snorlax":
            return { name:"Snorlax", sprite_index:7,
                types:[ELEMENT.NORMAL],
                hp:160, atk:110, def:65, spa:65, spd:110, spe:30 };

        case "machamp":
            return { name:"Machamp", sprite_index:8,
                types:[ELEMENT.FIGHTING],
                hp:90, atk:130, def:80, spa:65, spd:85, spe:55 };

        case "rhydon":
            return { name:"Rhydon", sprite_index:9,
                types:[ELEMENT.GROUND, ELEMENT.ROCK],
                hp:105, atk:130, def:120, spa:45, spd:45, spe:40 };

        case "jolteon":
            return { name:"Jolteon", sprite_index:10,
                types:[ELEMENT.ELECTRIC],
                hp:65, atk:65, def:60, spa:110, spd:95, spe:130 };

        case "dragonite":
            return { name:"Dragonite", sprite_index:11,
                types:[ELEMENT.DRAGON, ELEMENT.FLYING],
                hp:91, atk:134, def:95, spa:100, spd:100, spe:80 };

        case "arcanine":
            return { name:"Arcanine", sprite_index:12,
                types:[ELEMENT.FIRE],
                hp:90, atk:110, def:80, spa:100, spd:80, spe:95 };

        // ======================
        // JOHTO (13–24)
        // ======================

        case "typhlosion":
            return { name:"Typhlosion", sprite_index:13,
                types:[ELEMENT.FIRE],
                hp:78, atk:84, def:78, spa:109, spd:85, spe:100 };

        case "feraligatr":
            return { name:"Feraligatr", sprite_index:14,
                types:[ELEMENT.WATER],
                hp:85, atk:105, def:100, spa:79, spd:83, spe:78 };

        case "meganium":
            return { name:"Meganium", sprite_index:15,
                types:[ELEMENT.GRASS],
                hp:80, atk:82, def:100, spa:83, spd:100, spe:80 };

        case "tyranitar":
            return { name:"Tyranitar", sprite_index:16,
                types:[ELEMENT.ROCK, ELEMENT.DARK],
                hp:100, atk:134, def:110, spa:95, spd:100, spe:61 };

        case "scizor":
            return { name:"Scizor", sprite_index:17,
                types:[ELEMENT.BUG, ELEMENT.STEEL],
                hp:70, atk:130, def:100, spa:55, spd:80, spe:65 };

        case "heracross":
            return { name:"Heracross", sprite_index:18,
                types:[ELEMENT.BUG, ELEMENT.FIGHTING],
                hp:80, atk:125, def:75, spa:40, spd:95, spe:85 };

        case "houndoom":
            return { name:"Houndoom", sprite_index:19,
                types:[ELEMENT.DARK, ELEMENT.FIRE],
                hp:75, atk:90, def:50, spa:110, spd:80, spe:95 };

        case "kingdra":
            return { name:"Kingdra", sprite_index:20,
                types:[ELEMENT.WATER, ELEMENT.DRAGON],
                hp:75, atk:95, def:95, spa:95, spd:95, spe:85 };

        case "skarmory":
            return { name:"Skarmory", sprite_index:21,
                types:[ELEMENT.STEEL, ELEMENT.FLYING],
                hp:65, atk:80, def:140, spa:40, spd:70, spe:70 };

        case "umbreon":
            return { name:"Umbreon", sprite_index:22,
                types:[ELEMENT.DARK],
                hp:95, atk:65, def:110, spa:60, spd:130, spe:65 };

        case "espeon":
            return { name:"Espeon", sprite_index:23,
                types:[ELEMENT.PSYCHIC],
                hp:65, atk:65, def:60, spa:130, spd:95, spe:110 };

        case "donphan":
            return { name:"Donphan", sprite_index:24,
                types:[ELEMENT.GROUND],
                hp:90, atk:120, def:120, spa:60, spd:60, spe:50 };

        // ======================
        // HOENN (25–36)
        // ======================

        case "blaziken":
            return { name:"Blaziken", sprite_index:25,
                types:[ELEMENT.FIRE, ELEMENT.FIGHTING],
                hp:80, atk:120, def:70, spa:110, spd:70, spe:80 };

        case "swampert":
            return { name:"Swampert", sprite_index:26,
                types:[ELEMENT.WATER, ELEMENT.GROUND],
                hp:100, atk:110, def:90, spa:85, spd:90, spe:60 };

        case "sceptile":
            return { name:"Sceptile", sprite_index:27,
                types:[ELEMENT.GRASS],
                hp:70, atk:85, def:65, spa:105, spd:85, spe:120 };

        case "gardevoir":
            return { name:"Gardevoir", sprite_index:28,
                types:[ELEMENT.PSYCHIC],
                hp:68, atk:65, def:65, spa:125, spd:115, spe:80 };

        case "metagross":
            return { name:"Metagross", sprite_index:29,
                types:[ELEMENT.STEEL, ELEMENT.PSYCHIC],
                hp:80, atk:135, def:130, spa:95, spd:90, spe:70 };

        case "salamence":
            return { name:"Salamence", sprite_index:30,
                types:[ELEMENT.DRAGON, ELEMENT.FLYING],
                hp:95, atk:135, def:80, spa:110, spd:80, spe:100 };

        case "milotic":
            return { name:"Milotic", sprite_index:31,
                types:[ELEMENT.WATER],
                hp:95, atk:60, def:79, spa:100, spd:125, spe:81 };

        case "aggron":
            return { name:"Aggron", sprite_index:32,
                types:[ELEMENT.STEEL, ELEMENT.ROCK],
                hp:70, atk:110, def:180, spa:60, spd:60, spe:50 };

        case "flygon":
            return { name:"Flygon", sprite_index:33,
                types:[ELEMENT.GROUND, ELEMENT.DRAGON],
                hp:80, atk:100, def:80, spa:80, spd:80, spe:100 };

        case "manectric":
            return { name:"Manectric", sprite_index:34,
                types:[ELEMENT.ELECTRIC],
                hp:70, atk:75, def:60, spa:105, spd:60, spe:105 };

        case "tropius":
            return { name:"Tropius", sprite_index:35,
                types:[ELEMENT.GRASS, ELEMENT.FLYING],
                hp:99, atk:68, def:83, spa:72, spd:87, spe:51 };

        case "dusclops":
            return { name:"Dusclops", sprite_index:36,
                types:[ELEMENT.GHOST],
                hp:40, atk:70, def:130, spa:60, spd:130, spe:25 };

        default:
            show_debug_message("ERROR: Pokemon " + string(_species_id) + " not found.");
            return {
                name:"MissingNo",
                sprite_index:0,
                types:[ELEMENT.NORMAL],
                hp:10, atk:10, def:10, spa:10, spd:10, spe:10
            };
    }
}
