/// @desc Database of Pokemon Base Stats (Gen 3 - Hoenn Final Evolutions Only)
function get_pokemon_species(_species_id) {

    switch(_species_id) {

        // STARTERS
        case "sceptile": return { name:"Sceptile", types:[ELEMENT.GRASS], hp:70, atk:85, def:65, spa:105, spd:85, spe:120 };
        case "blaziken": return { name:"Blaziken", types:[ELEMENT.FIRE, ELEMENT.FIGHTING], hp:80, atk:120, def:70, spa:110, spd:70, spe:80 };
        case "swampert": return { name:"Swampert", types:[ELEMENT.WATER, ELEMENT.GROUND], hp:100, atk:110, def:90, spa:85, spd:90, spe:60 };

        // EARLY ROUTE
        case "mightyena": return { name:"Mightyena", types:[ELEMENT.DARK], hp:70, atk:90, def:70, spa:60, spd:60, spe:70 };
        case "linoone": return { name:"Linoone", types:[ELEMENT.NORMAL], hp:78, atk:70, def:61, spa:50, spd:61, spe:100 };
        case "beautifly": return { name:"Beautifly", types:[ELEMENT.BUG, ELEMENT.FLYING], hp:60, atk:70, def:50, spa:100, spd:50, spe:65 };
        case "dustox": return { name:"Dustox", types:[ELEMENT.BUG, ELEMENT.POISON], hp:60, atk:50, def:70, spa:50, spd:90, spe:65 };
        case "swellow": return { name:"Swellow", types:[ELEMENT.NORMAL, ELEMENT.FLYING], hp:60, atk:85, def:60, spa:50, spd:50, spe:125 };

        // WATER LINES
        case "pelipper": return { name:"Pelipper", types:[ELEMENT.WATER, ELEMENT.FLYING], hp:60, atk:50, def:100, spa:85, spd:70, spe:65 };
        case "masquerain": return { name:"Masquerain", types:[ELEMENT.BUG, ELEMENT.FLYING], hp:70, atk:60, def:62, spa:80, spd:82, spe:60 };
        case "breloom": return { name:"Breloom", types:[ELEMENT.GRASS, ELEMENT.FIGHTING], hp:60, atk:130, def:80, spa:60, spd:60, spe:70 };
        case "slaking": return { name:"Slaking", types:[ELEMENT.NORMAL], hp:150, atk:160, def:100, spa:95, spd:65, spe:100 };
        case "ninjask": return { name:"Ninjask", types:[ELEMENT.BUG, ELEMENT.FLYING], hp:61, atk:90, def:45, spa:50, spd:50, spe:160 };
        case "shedinja": return { name:"Shedinja", types:[ELEMENT.BUG, ELEMENT.GHOST], hp:1, atk:90, def:45, spa:30, spd:30, spe:40 };

        // NORMAL / FIELD
        case "exploud": return { name:"Exploud", types:[ELEMENT.NORMAL], hp:104, atk:91, def:63, spa:91, spd:73, spe:68 };
        case "delcatty": return { name:"Delcatty", types:[ELEMENT.NORMAL], hp:70, atk:65, def:65, spa:55, spd:55, spe:70 };

        // FIGHTING / PSYCHIC
        case "hariyama": return { name:"Hariyama", types:[ELEMENT.FIGHTING], hp:144, atk:120, def:60, spa:40, spd:60, spe:50 };
        case "medicham": return { name:"Medicham", types:[ELEMENT.FIGHTING, ELEMENT.PSYCHIC], hp:60, atk:60, def:75, spa:60, spd:75, spe:80 };
        case "grumpig": return { name:"Grumpig", types:[ELEMENT.PSYCHIC], hp:80, atk:45, def:65, spa:90, spd:110, spe:80 };

        // ELECTRIC
        case "manectric": return { name:"Manectric", types:[ELEMENT.ELECTRIC], hp:70, atk:75, def:60, spa:105, spd:60, spe:105 };

        // ROCK / GROUND / FIRE
        case "camerupt": return { name:"Camerupt", types:[ELEMENT.FIRE, ELEMENT.GROUND], hp:70, atk:100, def:70, spa:105, spd:75, spe:40 };
        case "torkoal": return { name:"Torkoal", types:[ELEMENT.FIRE], hp:70, atk:85, def:140, spa:85, spd:70, spe:20 };
        case "claydol": return { name:"Claydol", types:[ELEMENT.GROUND, ELEMENT.PSYCHIC], hp:60, atk:70, def:105, spa:70, spd:120, spe:75 };

        // GRASS / WATER
        case "ludicolo": return { name:"Ludicolo", types:[ELEMENT.WATER, ELEMENT.GRASS], hp:80, atk:70, def:70, spa:90, spd:100, spe:70 };
        case "shiftry": return { name:"Shiftry", types:[ELEMENT.GRASS, ELEMENT.DARK], hp:90, atk:100, def:60, spa:90, spd:60, spe:80 };

        // GHOST
        case "banette": return { name:"Banette", types:[ELEMENT.GHOST], hp:64, atk:115, def:65, spa:83, spd:63, spe:65 };
        case "dusclops": return { name:"Dusclops", types:[ELEMENT.GHOST], hp:40, atk:70, def:130, spa:60, spd:130, spe:25 };

        // ICE / WATER
        case "glalie": return { name:"Glalie", types:[ELEMENT.ICE], hp:80, atk:80, def:80, spa:80, spd:80, spe:80 };
        case "walrein": return { name:"Walrein", types:[ELEMENT.ICE, ELEMENT.WATER], hp:110, atk:80, def:90, spa:95, spd:90, spe:65 };

        // FOSSILS
        case "armaldo": return { name:"Armaldo", types:[ELEMENT.ROCK, ELEMENT.BUG], hp:75, atk:125, def:100, spa:70, spd:80, spe:45 };
        case "cradily": return { name:"Cradily", types:[ELEMENT.ROCK, ELEMENT.GRASS], hp:86, atk:81, def:97, spa:81, spd:107, spe:43 };

        // DRAGON
        case "altaria": return { name:"Altaria", types:[ELEMENT.DRAGON, ELEMENT.FLYING], hp:75, atk:70, def:90, spa:70, spd:105, spe:80 };
        case "flygon": return { name:"Flygon", types:[ELEMENT.GROUND, ELEMENT.DRAGON], hp:80, atk:100, def:80, spa:80, spd:80, spe:100 };
        case "salamence": return { name:"Salamence", types:[ELEMENT.DRAGON, ELEMENT.FLYING], hp:95, atk:135, def:80, spa:110, spd:80, spe:100 };

        // SINGLE STAGE
        case "absol": return { name:"Absol", types:[ELEMENT.DARK], hp:65, atk:130, def:60, spa:75, spd:60, spe:75 };
        case "tropius": return { name:"Tropius", types:[ELEMENT.GRASS, ELEMENT.FLYING], hp:99, atk:68, def:83, spa:72, spd:87, spe:51 };

        // PSEUDO LEGENDARY
        case "metagross": return { name:"Metagross", types:[ELEMENT.STEEL, ELEMENT.PSYCHIC], hp:80, atk:135, def:130, spa:95, spd:90, spe:70 };

        // LEGENDARIES
        case "regirock": return { name:"Regirock", types:[ELEMENT.ROCK], hp:80, atk:100, def:200, spa:50, spd:100, spe:50 };
        case "regice": return { name:"Regice", types:[ELEMENT.ICE], hp:80, atk:50, def:100, spa:100, spd:200, spe:50 };
        case "registeel": return { name:"Registeel", types:[ELEMENT.STEEL], hp:80, atk:75, def:150, spa:75, spd:150, spe:50 };

        case "latias": return { name:"Latias", types:[ELEMENT.DRAGON, ELEMENT.PSYCHIC], hp:80, atk:80, def:90, spa:110, spd:130, spe:110 };
        case "latios": return { name:"Latios", types:[ELEMENT.DRAGON, ELEMENT.PSYCHIC], hp:80, atk:90, def:80, spa:130, spd:110, spe:110 };

        case "kyogre": return { name:"Kyogre", types:[ELEMENT.WATER], hp:100, atk:100, def:90, spa:150, spd:140, spe:90 };
        case "groudon": return { name:"Groudon", types:[ELEMENT.GROUND], hp:100, atk:150, def:140, spa:100, spd:90, spe:90 };
        case "rayquaza": return { name:"Rayquaza", types:[ELEMENT.DRAGON, ELEMENT.FLYING], hp:105, atk:150, def:90, spa:150, spd:90, spe:95 };

        case "jirachi": return { name:"Jirachi", types:[ELEMENT.STEEL, ELEMENT.PSYCHIC], hp:100, atk:100, def:100, spa:100, spd:100, spe:100 };
        case "deoxys": return { name:"Deoxys", types:[ELEMENT.PSYCHIC], hp:50, atk:150, def:50, spa:150, spd:50, spe:150 };

    }

    return undefined;
}
