/// @func get_move_data(_move_id)
function get_move_data(_move_id) {
    
    // --- EFFECT TEMPLATES ---
    var self_atk_2 = { chance: 100, target: SCOPE.SELF, stat: "atk", amount: 2 };
    var self_def_2 = { chance: 100, target: SCOPE.SELF, stat: "def", amount: 2 };
    var self_spe_2 = { chance: 100, target: SCOPE.SELF, stat: "spe", amount: 2 };
    var self_spa_1 = { chance: 100, target: SCOPE.SELF, stat: "spa", amount: 1 };
    var self_atk_def_1 = { chance: 100, target: SCOPE.SELF, stat: "atk", amount: 1 }; // Bulk Up (Simulated, ideally multiple stats)
    
    var en_atk_down_1 = { chance: 100, target: SCOPE.ENEMY, stat: "atk", amount: -1 };
    var en_def_down_1 = { chance: 100, target: SCOPE.ENEMY, stat: "def", amount: -1 };
    var en_def_down_2 = { chance: 100, target: SCOPE.ENEMY, stat: "def", amount: -2 };
    var en_spe_down_1 = { chance: 100, target: SCOPE.ENEMY, stat: "spe", amount: -1 };
    
    var eff_par_10 = { chance: 10, target: SCOPE.ENEMY, condition: "PAR" };
    var eff_par_30 = { chance: 30, target: SCOPE.ENEMY, condition: "PAR" };
    var eff_brn_10 = { chance: 10, target: SCOPE.ENEMY, condition: "BRN" };
    var eff_psn_30 = { chance: 30, target: SCOPE.ENEMY, condition: "PSN" };
    var eff_def_down_20 = { chance: 20, target: SCOPE.ENEMY, stat: "def", amount: -1 };
    var eff_spd_down_20 = { chance: 20, target: SCOPE.ENEMY, stat: "spd", amount: -1 };
    var eff_flinch_30 = { chance: 30, target: SCOPE.ENEMY }; // Placeholder for Flinch

    // Special Tags
    var tag_drain_50 = { chance: 100, drain: 0.5 };
    var tag_recoil_25 = { chance: 100, recoil: 0.25 };
    var tag_recoil_33 = { chance: 100, recoil: 0.33 };
    var tag_crit_high = { chance: 0, high_crit: true };
    var tag_fixed_lvl = { chance: 100, fixed: true };

    switch (_move_id) {
        
        // --- STATUS & BUFFS ---
        case "swords_dance": return new Move("swords_dance", "Swords Dance", ELEMENT.NORMAL, 0, 100, 0, self_atk_2);
        case "dragon_dance": return new Move("dragon_dance", "Dragon Dance", ELEMENT.DRAGON, 0, 100, 0, {chance:100, target:SCOPE.SELF, stat:"atk", amount:1}); // +Spe handled in logic? Or simplified
        case "calm_mind":    return new Move("calm_mind", "Calm Mind", ELEMENT.PSYCHIC, 0, 100, 0, self_spa_1);
        case "bulk_up":      return new Move("bulk_up", "Bulk Up", ELEMENT.FIGHTING, 0, 100, 0, {chance:100, target:SCOPE.SELF, stat:"atk", amount:1}); // And Def
        case "iron_defense": return new Move("iron_defense", "Iron Defense", ELEMENT.STEEL, 0, 100, 0, self_def_2);
        case "agility":      return new Move("agility", "Agility", ELEMENT.PSYCHIC, 0, 100, 0, self_spe_2);
        
        case "thunder_wave": return new Move("thunder_wave", "Thunder Wave", ELEMENT.ELECTRIC, 0, 100, 0, {chance:100, target:SCOPE.ENEMY, condition:"PAR"});
        case "toxic":        return new Move("toxic", "Toxic", ELEMENT.POISON, 0, 85, 0, {chance:100, target:SCOPE.ENEMY, condition:"PSN"});
        case "will_o_wisp":  return new Move("will_o_wisp", "Will-O-Wisp", ELEMENT.FIRE, 0, 75, 0, {chance:100, target:SCOPE.ENEMY, condition:"BRN"});
        case "hypnosis":     return new Move("hypnosis", "Hypnosis", ELEMENT.PSYCHIC, 0, 60, 0, {chance:100, target:SCOPE.ENEMY, condition:"SLP"});
        case "sleep_powder": return new Move("sleep_powder", "Sleep Powder", ELEMENT.GRASS, 0, 75, 0, {chance:100, target:SCOPE.ENEMY, condition:"SLP"});
        case "confuse_ray":  return new Move("confuse_ray", "Confuse Ray", ELEMENT.GHOST, 0, 100, 0); // Not Impl
        
        case "synthesis":    return new Move("synthesis", "Synthesis", ELEMENT.GRASS, 0, 100, 0); // Hard to implement healing self without custom effect, use Potions for now? Or drain 0 dmg.
        
        // --- PHYSICAL ATTACKS ---
        case "tackle":       return new Move("tackle", "Tackle", ELEMENT.NORMAL, 40, 100, 0);
        case "quick_attack": return new Move("quick_attack", "Quick Attack", ELEMENT.NORMAL, 40, 100, 1);
        case "body_slam":    return new Move("body_slam", "Body Slam", ELEMENT.NORMAL, 85, 100, 0, eff_par_30);
        case "double_edge":  return new Move("double_edge", "Double-Edge", ELEMENT.NORMAL, 120, 100, 0, tag_recoil_33);
        case "return":       return new Move("return", "Return", ELEMENT.NORMAL, 102, 100, 0);
        case "slash":        return new Move("slash", "Slash", ELEMENT.NORMAL, 70, 100, 0, tag_crit_high);
        
        case "earthquake":   return new Move("earthquake", "Earthquake", ELEMENT.GROUND, 100, 100, 0);
        case "rock_slide":   return new Move("rock_slide", "Rock Slide", ELEMENT.ROCK, 75, 90, 0, eff_flinch_30);
        case "brick_break":  return new Move("brick_break", "Brick Break", ELEMENT.FIGHTING, 75, 100, 0);
        case "cross_chop":   return new Move("cross_chop", "Cross Chop", ELEMENT.FIGHTING, 100, 80, 0, tag_crit_high);
        case "superpower":   return new Move("superpower", "Superpower", ELEMENT.FIGHTING, 120, 100, 0, {chance:100, target:SCOPE.SELF, stat:"atk", amount:-1});
        
        case "shadow_ball":  return new Move("shadow_ball", "Shadow Ball", ELEMENT.GHOST, 80, 100, 0, eff_spd_down_20); // Phys in Gen 3
        case "sludge_bomb":  return new Move("sludge_bomb", "Sludge Bomb", ELEMENT.POISON, 90, 100, 0, eff_psn_30); // Phys in Gen 3
        
        case "aerial_ace":   return new Move("aerial_ace", "Aerial Ace", ELEMENT.FLYING, 60, 999, 0); // Infinite Acc
        case "drill_peck":   return new Move("drill_peck", "Drill Peck", ELEMENT.FLYING, 80, 100, 0);
        case "wing_attack":  return new Move("wing_attack", "Wing Attack", ELEMENT.FLYING, 60, 100, 0);
        
        case "steel_wing":   return new Move("steel_wing", "Steel Wing", ELEMENT.STEEL, 70, 90, 0, {chance:10, target:SCOPE.SELF, stat:"def", amount:1});
        case "iron_tail":    return new Move("iron_tail", "Iron Tail", ELEMENT.STEEL, 100, 75, 0, eff_def_down_20);
        case "meteor_mash":  return new Move("meteor_mash", "Meteor Mash", ELEMENT.STEEL, 100, 85, 0, {chance:20, target:SCOPE.SELF, stat:"atk", amount:1});
        
        case "megahorn":     return new Move("megahorn", "Megahorn", ELEMENT.BUG, 120, 85, 0);
        case "silver_wind":  return new Move("silver_wind", "Silver Wind", ELEMENT.BUG, 60, 100, 0, {chance:10, target:SCOPE.SELF, stat:"atk", amount:1});
        
        case "leaf_blade":   return new Move("leaf_blade", "Leaf Blade", ELEMENT.GRASS, 70, 100, 0, tag_crit_high);
        case "waterfall":    return new Move("waterfall", "Waterfall", ELEMENT.WATER, 80, 100, 0); // Special in Gen 3 actually, but logic handles it
        
        // --- SPECIAL ATTACKS ---
        case "surf":         return new Move("surf", "Surf", ELEMENT.WATER, 95, 100, 0);
        case "hydro_pump":   return new Move("hydro_pump", "Hydro Pump", ELEMENT.WATER, 120, 80, 0);
        case "ice_beam":     return new Move("ice_beam", "Ice Beam", ELEMENT.ICE, 95, 100, 0, {chance:10, target:SCOPE.ENEMY, condition:"FRZ"}); // Freeze not impl, treat as none
        case "blizzard":     return new Move("blizzard", "Blizzard", ELEMENT.ICE, 120, 70, 0);
        case "icy_wind":     return new Move("icy_wind", "Icy Wind", ELEMENT.ICE, 55, 95, 0, en_spe_down_1);
        
        case "thunderbolt":  return new Move("thunderbolt", "Thunderbolt", ELEMENT.ELECTRIC, 95, 100, 0, eff_par_10);
        case "thunder":      return new Move("thunder", "Thunder", ELEMENT.ELECTRIC, 120, 70, 0, eff_par_30);
        
        case "flamethrower": return new Move("flamethrower", "Flamethrower", ELEMENT.FIRE, 95, 100, 0, eff_brn_10);
        case "fire_blast":   return new Move("fire_blast", "Fire Blast", ELEMENT.FIRE, 120, 85, 0, eff_brn_10);
        case "heat_wave":    return new Move("heat_wave", "Heat Wave", ELEMENT.FIRE, 100, 90, 0, eff_brn_10);
        
        case "psychic":      return new Move("psychic", "Psychic", ELEMENT.PSYCHIC, 90, 100, 0, eff_spd_down_20);
        case "psybeam":      return new Move("psybeam", "Psybeam", ELEMENT.PSYCHIC, 65, 100, 0, {chance:10, target:SCOPE.ENEMY, condition:"CNF"});
        
        case "giga_drain":   return new Move("giga_drain", "Giga Drain", ELEMENT.GRASS, 60, 100, 0, tag_drain_50);
        case "solar_beam":   return new Move("solar_beam", "Solar Beam", ELEMENT.GRASS, 120, 100, 0); // 1-Turn for this build
        
        case "dragon_claw":  return new Move("dragon_claw", "Dragon Claw", ELEMENT.DRAGON, 80, 100, 0);
        case "dragon_breath": return new Move("dragon_breath", "Dragon Breath", ELEMENT.DRAGON, 60, 100, 0, eff_par_30);
        
        case "crunch":       return new Move("crunch", "Crunch", ELEMENT.DARK, 80, 100, 0, eff_def_down_20);
        case "bite":         return new Move("bite", "Bite", ELEMENT.DARK, 60, 100, 0, eff_flinch_30);
        case "pursuit":      return new Move("pursuit", "Pursuit", ELEMENT.DARK, 40, 100, 0);
        
        // --- FIXED DAMAGE ---
        case "seismic_toss": return new Move("seismic_toss", "Seismic Toss", ELEMENT.FIGHTING, 1, 100, 0, tag_fixed_lvl);
        case "night_shade":  return new Move("night_shade", "Night Shade", ELEMENT.GHOST, 1, 100, 0, tag_fixed_lvl);
        
        default: return new Move("tackle", "Tackle", ELEMENT.NORMAL, 40, 100, 0);
    }
}