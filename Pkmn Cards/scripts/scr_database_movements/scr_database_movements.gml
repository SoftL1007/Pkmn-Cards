/// @func get_move_data(_move_id)
function get_move_data(_move_id) {
    
    // STAT MODIFIERS
    var st_atk_up1 = { chance: 100, target: SCOPE.SELF, stat: "atk", amount: 1 };
    var st_def_up2 = { chance: 100, target: SCOPE.SELF, stat: "def", amount: 2 };
    var st_spe_up2 = { chance: 100, target: SCOPE.SELF, stat: "spe", amount: 2 };
    
    var st_atk_down1 = { chance: 100, target: SCOPE.ENEMY, stat: "atk", amount: -1 };
    var st_def_down1 = { chance: 100, target: SCOPE.ENEMY, stat: "def", amount: -1 };
    var st_def_down2 = { chance: 100, target: SCOPE.ENEMY, stat: "def", amount: -2 };
    var st_spe_down1 = { chance: 100, target: SCOPE.ENEMY, stat: "spe", amount: -1 };
    var st_acc_down1 = { chance: 100, target: SCOPE.ENEMY, stat: "acc", amount: -1 }; 

    var eff_def_down = { chance: 30, target: SCOPE.ENEMY, stat: "def", amount: -1 };
    
    // STATUS CONDITIONS
    var set_par = { chance: 100, target: SCOPE.ENEMY, condition: "PAR" };
    var set_brn = { chance: 100, target: SCOPE.ENEMY, condition: "BRN" };
    var set_psn = { chance: 100, target: SCOPE.ENEMY, condition: "PSN" };
    var set_slp = { chance: 100, target: SCOPE.ENEMY, condition: "SLP" };
    
    // Secondary Status Effects
    var eff_par_10 = { chance: 10, target: SCOPE.ENEMY, condition: "PAR" };
    var eff_par_30 = { chance: 30, target: SCOPE.ENEMY, condition: "PAR" };
    var eff_brn_10 = { chance: 10, target: SCOPE.ENEMY, condition: "BRN" };
    var eff_psn_30 = { chance: 30, target: SCOPE.ENEMY, condition: "PSN" };

    switch (_move_id) {
        
        // --- NEW STATUS CONDITION MOVES ---
        case "thunder_wave": return new Move("thunder_wave", "Thunder Wave", ELEMENT.ELECTRIC, 0, 100, 0, set_par);
        case "stun_spore":   return new Move("stun_spore", "Stun Spore", ELEMENT.GRASS, 0, 75, 0, set_par);
        case "will_o_wisp":  return new Move("will_o_wisp", "Will-O-Wisp", ELEMENT.FIRE, 0, 75, 0, set_brn);
        case "toxic":        return new Move("toxic", "Toxic", ELEMENT.POISON, 0, 85, 0, set_psn);
        case "poison_powder": return new Move("poison_powder", "Poison Powder", ELEMENT.POISON, 0, 75, 0, set_psn);
        case "hypnosis":     return new Move("hypnosis", "Hypnosis", ELEMENT.PSYCHIC, 0, 60, 0, set_slp);
        case "sleep_powder": return new Move("sleep_powder", "Sleep Powder", ELEMENT.GRASS, 0, 75, 0, set_slp);
        case "sing":         return new Move("sing", "Sing", ELEMENT.NORMAL, 0, 55, 0, set_slp);

        // --- STAT BUFF/DEBUFF MOVES ---
        case "swords_dance": return new Move("swords_dance", "Swords Dance", ELEMENT.NORMAL, 0, 100, 0, {chance:100, target:SCOPE.SELF, stat:"atk", amount:2});
        case "growl":        return new Move("growl", "Growl", ELEMENT.NORMAL, 0, 100, 0, st_atk_down1);
        case "leer":         return new Move("leer", "Leer", ELEMENT.NORMAL, 0, 100, 0, st_def_down1);
        case "tail_whip":    return new Move("tail_whip", "Tail Whip", ELEMENT.NORMAL, 0, 100, 0, st_def_down1);
        case "iron_defense": return new Move("iron_defense", "Iron Defense", ELEMENT.STEEL, 0, 100, 0, st_def_up2);
        case "agility":      return new Move("agility", "Agility", ELEMENT.PSYCHIC, 0, 100, 0, st_spe_up2);
        case "screech":      return new Move("screech", "Screech", ELEMENT.NORMAL, 0, 85, 0, st_def_down2);
        case "sand_attack":  return new Move("sand_attack", "Sand Attack", ELEMENT.GROUND, 0, 100, 0, st_acc_down1);
        case "calm_mind":    return new Move("calm_mind","Calm Mind",ELEMENT.PSYCHIC,0,100,0, {chance:100, target:SCOPE.SELF, stat:"spa", amount:1}); 
        case "dragon_dance": return new Move("dragon_dance","Dragon Dance",ELEMENT.DRAGON,0,200,0, st_atk_up1);

        // --- ATTACKS ---
        case "body_slam": return new Move("body_slam","Body Slam",ELEMENT.NORMAL,85,100,0, eff_par_30);
        case "thunderbolt": return new Move("thunderbolt","Thunderbolt",ELEMENT.ELECTRIC,95,100,0, eff_par_10);
        case "thunder": return new Move("thunder","Thunder",ELEMENT.ELECTRIC,120,70,0, eff_par_30);
        case "flamethrower": return new Move("flamethrower","Flamethrower",ELEMENT.FIRE,95,100,0, eff_brn_10); 
        case "sludge": return new Move("sludge","Sludge",ELEMENT.POISON,65,100,0, eff_psn_30);
        case "crunch": return new Move("crunch","Crunch",ELEMENT.DARK,80,100,0, eff_def_down);
        case "iron_tail": return new Move("iron_tail","Iron Tail",ELEMENT.STEEL,100,75,0, eff_def_down);
        case "psychic": return new Move("psychic","Psychic",ELEMENT.PSYCHIC,90,100,0, {chance:10, target:SCOPE.ENEMY, stat:"spd", amount:-1});
        case "shadow_ball": return new Move("shadow_ball","Shadow Ball",ELEMENT.GHOST,80,100,0, {chance:20, target:SCOPE.ENEMY, stat:"spd", amount:-1});
        case "icy_wind": return new Move("icy_wind","Icy Wind",ELEMENT.ICE,55,95,0, st_spe_down1);
        case "rock_tomb": return new Move("rock_tomb","Rock Tomb",ELEMENT.ROCK,50,80,0, st_spe_down1);
        case "mud_slap": return new Move("mud_slap","Mud-Slap",ELEMENT.GROUND,20,100,0, st_acc_down1);

        // Standards (No Effect or not implemented yet)
        case "tackle": return new Move("tackle","Tackle",ELEMENT.NORMAL,40,100,0);
        case "quick_attack": return new Move("quick_attack","Quick Attack",ELEMENT.NORMAL,40,100,1);
        case "slash": return new Move("slash","Slash",ELEMENT.NORMAL,70,100,0);
        case "surf": return new Move("surf","Surf",ELEMENT.WATER,90,100,0);
        case "earthquake": return new Move("earthquake","Earthquake",ELEMENT.GROUND,100,100,0);
        
        default: return new Move("tackle","Tackle",ELEMENT.NORMAL,40,100,0);
    }
}