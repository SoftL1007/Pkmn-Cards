/// @desc Database of Cards
function get_card_data(_card_id) {
    
    // --- HEALING EVENTS (Cannot be in Deck) ---
    // Frame Indices: 0 - 9
    switch(_card_id) {
        case "potion":          return new BattleCard("potion", "Potion", "Restores 20 HP", SCOPE.SELF, CARD_TYPE.EVENT, RARITY.COMMON, 0);
        case "potion_super":    return new BattleCard("potion_super", "Super Potion", "Restores 60 HP", SCOPE.SELF, CARD_TYPE.EVENT, RARITY.COMMON, 1);
        case "potion_hyper":    return new BattleCard("potion_hyper", "Hyper Potion", "Restores 200 HP", SCOPE.SELF, CARD_TYPE.EVENT, RARITY.RARE, 2);
        case "potion_max":      return new BattleCard("potion_max", "Max Potion", "Fully Restores HP", SCOPE.SELF, CARD_TYPE.EVENT, RARITY.EPIC, 3);
        case "full_restore":    return new BattleCard("full_restore", "Full Restore", "Full HP + Status Clear", SCOPE.SELF, CARD_TYPE.EVENT, RARITY.LEGENDARY, 4);
        case "revive":          return new BattleCard("revive", "Revive", "Revives with 50% HP", SCOPE.SELF, CARD_TYPE.EVENT, RARITY.RARE, 5);
        case "revive_max":      return new BattleCard("revive_max", "Max Revive", "Revives with 100% HP", SCOPE.SELF, CARD_TYPE.EVENT, RARITY.EPIC, 6);
        case "heal_par":        return new BattleCard("heal_par", "Paralyze Heal", "Cures Paralysis", SCOPE.SELF, CARD_TYPE.EVENT, RARITY.COMMON, 7);
        case "heal_brn":        return new BattleCard("heal_brn", "Burn Heal", "Cures Burn", SCOPE.SELF, CARD_TYPE.EVENT, RARITY.COMMON, 8);
        case "heal_psn":        return new BattleCard("heal_psn", "Antidote", "Cures Poison", SCOPE.SELF, CARD_TYPE.EVENT, RARITY.COMMON, 9);
        
        // --- MAGIC CARDS (Buffs/Debuffs) ---
        // Frame Indices: 10 - 49
        
        // ATTACK BUFFS
        case "x_atk":           return new BattleCard("x_atk", "X Attack", "Atk +1 Stage", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.COMMON, 10, {stat:"atk", val:1});
        case "x_atk_2":         return new BattleCard("x_atk_2", "X Attack EX", "Atk +2 Stages", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.RARE, 11, {stat:"atk", val:2});
        case "x_spa":           return new BattleCard("x_spa", "X Sp.Atk", "Sp.Atk +1 Stage", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.COMMON, 12, {stat:"spa", val:1});
        case "x_spa_2":         return new BattleCard("x_spa_2", "X Sp.Atk EX", "Sp.Atk +2 Stages", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.RARE, 13, {stat:"spa", val:2});
        case "muscle_band":     return new BattleCard("muscle_band", "Muscle Band", "Atk +1 (Perm)", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.EPIC, 14, {stat:"atk", val:1}); // Treated same logic for now
        
        // DEFENSE BUFFS
        case "x_def":           return new BattleCard("x_def", "X Defense", "Def +1 Stage", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.COMMON, 20, {stat:"def", val:1});
        case "x_def_2":         return new BattleCard("x_def_2", "X Defense EX", "Def +2 Stages", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.RARE, 21, {stat:"def", val:2});
        case "x_spd":           return new BattleCard("x_spd", "X Sp.Def", "Sp.Def +1 Stage", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.COMMON, 22, {stat:"spd", val:1});
        case "x_spd_2":         return new BattleCard("x_spd_2", "X Sp.Def EX", "Sp.Def +2 Stages", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.RARE, 23, {stat:"spd", val:2});
        case "iron_wall":       return new BattleCard("iron_wall", "Iron Wall", "Def & Sp.Def +1", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.EPIC, 24, {stat:"both_def", val:1});
        
        // SPEED/UTILITY
        case "x_spe":           return new BattleCard("x_spe", "X Speed", "Speed +1 Stage", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.COMMON, 30, {stat:"spe", val:1});
        case "x_spe_2":         return new BattleCard("x_spe_2", "X Speed EX", "Speed +2 Stages", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.RARE, 31, {stat:"spe", val:2});
        case "quick_claw":      return new BattleCard("quick_claw", "Quick Claw", "Next move priority +1", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.RARE, 32, {special:"priority"});
        case "focus_energy":    return new BattleCard("focus_energy", "Focus Energy", "Next hit Critical", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.RARE, 33, {special:"crit"});
        case "double_team":     return new BattleCard("double_team", "Double Team", "Evasion +1", SCOPE.SELF, CARD_TYPE.MAGIC, RARITY.COMMON, 34, {stat:"eva", val:1});
        
        // DEBUFFS (Target Enemy)
        case "growl_card":      return new BattleCard("growl_card", "Intimidate", "Enemy Atk -1", SCOPE.ENEMY, CARD_TYPE.MAGIC, RARITY.COMMON, 40, {stat:"atk", val:-1});
        case "leer_card":       return new BattleCard("leer_card", "Glare", "Enemy Def -1", SCOPE.ENEMY, CARD_TYPE.MAGIC, RARITY.COMMON, 41, {stat:"def", val:-1});
        case "string_shot":     return new BattleCard("string_shot", "String Shot", "Enemy Spe -1", SCOPE.ENEMY, CARD_TYPE.MAGIC, RARITY.COMMON, 42, {stat:"spe", val:-1});
        case "scary_face":      return new BattleCard("scary_face", "Scary Face", "Enemy Spe -2", SCOPE.ENEMY, CARD_TYPE.MAGIC, RARITY.RARE, 43, {stat:"spe", val:-2});
        case "charm":           return new BattleCard("charm", "Charm", "Enemy Atk -2", SCOPE.ENEMY, CARD_TYPE.MAGIC, RARITY.RARE, 44, {stat:"atk", val:-2});
        case "fake_tears":      return new BattleCard("fake_tears", "Fake Tears", "Enemy Sp.Def -2", SCOPE.ENEMY, CARD_TYPE.MAGIC, RARITY.RARE, 45, {stat:"spd", val:-2});
        case "flash":           return new BattleCard("flash", "Flash", "Enemy Acc -1", SCOPE.ENEMY, CARD_TYPE.MAGIC, RARITY.COMMON, 46, {stat:"acc", val:-1});
        case "will_o_wisp_c":   return new BattleCard("will_o_wisp_c", "Will-O-Wisp", "Burn Enemy", SCOPE.ENEMY, CARD_TYPE.MAGIC, RARITY.EPIC, 47, {status:"BRN"});
        case "thunder_wave_c":  return new BattleCard("thunder_wave_c", "Thunder Wave", "Paralyze Enemy", SCOPE.ENEMY, CARD_TYPE.MAGIC, RARITY.EPIC, 48, {status:"PAR"});
        case "toxic_c":         return new BattleCard("toxic_c", "Toxic Orb", "Poison Enemy", SCOPE.ENEMY, CARD_TYPE.MAGIC, RARITY.EPIC, 49, {status:"PSN"});
        
        // --- TRAP CARDS (Face Down) ---
        // Frame Indices: 50 - 59
        // triggers: "phys_atk", "spec_atk", "any_atk", "contact"
        
        case "counter_trap":    return new BattleCard("counter_trap", "Counter", "Reflects Physical Dmg", SCOPE.SELF, CARD_TYPE.TRAP, RARITY.RARE, 50, {trigger:"phys_atk", effect:"reflect"});
        case "mirror_coat":     return new BattleCard("mirror_coat", "Mirror Coat", "Reflects Special Dmg", SCOPE.SELF, CARD_TYPE.TRAP, RARITY.RARE, 51, {trigger:"spec_atk", effect:"reflect"});
        case "protect_trap":    return new BattleCard("protect_trap", "Protect", "Blocks any attack", SCOPE.SELF, CARD_TYPE.TRAP, RARITY.EPIC, 52, {trigger:"any_atk", effect:"block"});
        case "poison_barb":     return new BattleCard("poison_barb", "Poison Point", "Poisons attacker", SCOPE.SELF, CARD_TYPE.TRAP, RARITY.COMMON, 53, {trigger:"contact", effect:"poison"});
        case "static_trap":     return new BattleCard("static_trap", "Static", "Paralyzes attacker", SCOPE.SELF, CARD_TYPE.TRAP, RARITY.COMMON, 54, {trigger:"contact", effect:"paralyze"});
        case "rough_skin":      return new BattleCard("rough_skin", "Rough Skin", "Hurts attacker (1/8 HP)", SCOPE.SELF, CARD_TYPE.TRAP, RARITY.COMMON, 55, {trigger:"contact", effect:"damage_8"});
        case "flame_body":      return new BattleCard("flame_body", "Flame Body", "Burns attacker", SCOPE.SELF, CARD_TYPE.TRAP, RARITY.COMMON, 56, {trigger:"contact", effect:"burn"});
        case "focus_sash":      return new BattleCard("focus_sash", "Endure", "Survive with 1 HP", SCOPE.SELF, CARD_TYPE.TRAP, RARITY.EPIC, 57, {trigger:"lethal", effect:"survive"});
    }
    return undefined;
}