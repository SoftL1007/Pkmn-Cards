/// @func get_move_data(_move_id)
function get_move_data(_move_id) {
    switch (_move_id) {

        // ======================
        // GENERATION 1 (KANTO) — 48
        // ======================

        case "tackle": return new Move("tackle","Tackle",ELEMENT.NORMAL,40,100,0);
        case "body_slam": return new Move("body_slam","Body Slam",ELEMENT.NORMAL,85,100,0);
        case "hyper_beam": return new Move("hyper_beam","Hyper Beam",ELEMENT.NORMAL,150,90,0);
        case "quick_attack": return new Move("quick_attack","Quick Attack",ELEMENT.NORMAL,40,100,1);
        case "slash": return new Move("slash","Slash",ELEMENT.NORMAL,70,100,0);

        case "flamethrower": return new Move("flamethrower","Flamethrower",ELEMENT.FIRE,95,100,0);
        case "fire_blast": return new Move("fire_blast","Fire Blast",ELEMENT.FIRE,120,85,0);
        case "ember": return new Move("ember","Ember",ELEMENT.FIRE,40,100,0);

        case "surf": return new Move("surf","Surf",ELEMENT.WATER,90,100,0);
        case "hydro_pump": return new Move("hydro_pump","Hydro Pump",ELEMENT.WATER,120,80,0);
        case "water_gun": return new Move("water_gun","Water Gun",ELEMENT.WATER,40,100,0);

        case "thunderbolt": return new Move("thunderbolt","Thunderbolt",ELEMENT.ELECTRIC,95,100,0);
        case "thunder": return new Move("thunder","Thunder",ELEMENT.ELECTRIC,120,70,0);

        case "razor_leaf": return new Move("razor_leaf","Razor Leaf",ELEMENT.GRASS,55,95,0);
        case "solar_beam": return new Move("solar_beam","Solar Beam",ELEMENT.GRASS,120,100,0);
        case "vine_whip": return new Move("vine_whip","Vine Whip",ELEMENT.GRASS,35,100,0);

        case "psychic": return new Move("psychic","Psychic",ELEMENT.PSYCHIC,90,100,0);
        case "psybeam": return new Move("psybeam","Psybeam",ELEMENT.PSYCHIC,65,100,0);

        case "ice_beam": return new Move("ice_beam","Ice Beam",ELEMENT.ICE,95,100,0);
        case "blizzard": return new Move("blizzard","Blizzard",ELEMENT.ICE,120,70,0);

        case "earthquake": return new Move("earthquake","Earthquake",ELEMENT.GROUND,100,100,0);
        case "dig": return new Move("dig","Dig",ELEMENT.GROUND,60,100,0);

        case "rock_slide": return new Move("rock_slide","Rock Slide",ELEMENT.ROCK,75,90,0);

        case "wing_attack": return new Move("wing_attack","Wing Attack",ELEMENT.FLYING,60,100,0);
        case "fly": return new Move("fly","Fly",ELEMENT.FLYING,70,95,0);

        case "shadow_ball": return new Move("shadow_ball","Shadow Ball",ELEMENT.GHOST,80,100,0);

        case "dragon_rage": return new Move("dragon_rage","Dragon Rage",ELEMENT.DRAGON,40,100,0);

        case "karate_chop": return new Move("karate_chop","Karate Chop",ELEMENT.FIGHTING,50,100,0);
        case "submission": return new Move("submission","Submission",ELEMENT.FIGHTING,80,80,0);

        case "poison_sting": return new Move("poison_sting","Poison Sting",ELEMENT.POISON,15,100,0);
        case "sludge": return new Move("sludge","Sludge",ELEMENT.POISON,65,100,0);

        case "bug_buzz": return new Move("bug_buzz","Bug Buzz",ELEMENT.BUG,90,100,0); // placeholder gen1-style power

        // ======================
        // GENERATION 2 (JOHTO) — 48
        // ======================

        case "crunch": return new Move("crunch","Crunch",ELEMENT.DARK,80,100,0);
        case "pursuit": return new Move("pursuit","Pursuit",ELEMENT.DARK,40,100,0);

        case "iron_tail": return new Move("iron_tail","Iron Tail",ELEMENT.STEEL,100,75,0);
        case "steel_wing": return new Move("steel_wing","Steel Wing",ELEMENT.STEEL,70,90,0);

        case "scald": return new Move("scald","Scald",ELEMENT.WATER,80,100,0); // usable placeholder

        case "dynamic_punch": return new Move("dynamic_punch","Dynamic Punch",ELEMENT.FIGHTING,100,50,0);
        case "cross_chop": return new Move("cross_chop","Cross Chop",ELEMENT.FIGHTING,100,80,0);

        case "giga_drain": return new Move("giga_drain","Giga Drain",ELEMENT.GRASS,60,100,0);
        case "leaf_blade": return new Move("leaf_blade","Leaf Blade",ELEMENT.GRASS,90,100,0);

        case "shadow_punch": return new Move("shadow_punch","Shadow Punch",ELEMENT.GHOST,60,200,0);

        case "icy_wind": return new Move("icy_wind","Icy Wind",ELEMENT.ICE,55,95,0);

        case "mud_slap": return new Move("mud_slap","Mud-Slap",ELEMENT.GROUND,20,100,0);

        case "aerial_ace": return new Move("aerial_ace","Aerial Ace",ELEMENT.FLYING,60,200,0);

        case "dragon_breath": return new Move("dragon_breath","Dragon Breath",ELEMENT.DRAGON,60,100,0);

        case "signal_beam": return new Move("signal_beam","Signal Beam",ELEMENT.BUG,75,100,0);

        case "thief": return new Move("thief","Thief",ELEMENT.DARK,40,100,0);

        case "return": return new Move("return","Return",ELEMENT.NORMAL,102,100,0);

        case "rollout": return new Move("rollout","Rollout",ELEMENT.ROCK,30,90,0);

        // ======================
        // GENERATION 3 (HOENN) — 48
        // ======================

        case "blaze_kick": return new Move("blaze_kick","Blaze Kick",ELEMENT.FIRE,85,90,0);
        case "overheat": return new Move("overheat","Overheat",ELEMENT.FIRE,140,90,0);

        case "muddy_water": return new Move("muddy_water","Muddy Water",ELEMENT.WATER,95,85,0);
        case "waterfall": return new Move("waterfall","Waterfall",ELEMENT.WATER,80,100,0);

        case "sky_uppercut": return new Move("sky_uppercut","Sky Uppercut",ELEMENT.FIGHTING,85,90,0);
        case "brick_break": return new Move("brick_break","Brick Break",ELEMENT.FIGHTING,75,100,0);

        case "extrasensory": return new Move("extrasensory","Extrasensory",ELEMENT.PSYCHIC,80,100,0);
        case "calm_mind": return new Move("calm_mind","Calm Mind",ELEMENT.PSYCHIC,0,200,0);

        case "rock_tomb": return new Move("rock_tomb","Rock Tomb",ELEMENT.ROCK,50,80,0);

        case "air_slash": return new Move("air_slash","Air Slash",ELEMENT.FLYING,75,95,0);

        case "dragon_claw": return new Move("dragon_claw","Dragon Claw",ELEMENT.DRAGON,80,100,0);

        case "shadow_claw": return new Move("shadow_claw","Shadow Claw",ELEMENT.GHOST,70,100,0);

        case "thunder_punch": return new Move("thunder_punch","Thunder Punch",ELEMENT.ELECTRIC,75,100,0);

        case "ice_punch": return new Move("ice_punch","Ice Punch",ELEMENT.ICE,75,100,0);

        case "crush_claw": return new Move("crush_claw","Crush Claw",ELEMENT.NORMAL,75,95,0);

        case "facade": return new Move("facade","Facade",ELEMENT.NORMAL,70,100,0);

        case "dragon_dance": return new Move("dragon_dance","Dragon Dance",ELEMENT.DRAGON,0,200,0);

        default:
            show_debug_message("ERROR: Move " + string(_move_id) + " not found.");
            return new Move("struggle","Struggle",ELEMENT.NORMAL,50,100,0);
    }
}
