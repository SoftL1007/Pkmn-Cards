if (array_length(action_queue) > 0) {
    var act = action_queue[0];
    array_delete(action_queue, 0, 1);
    
    // Check Faint
    if (act.actor.is_fainted()) {
        battle_log = act.actor.nickname + " fainted!";
        alarm[0] = 60;
        exit;
    }
    
    // --- CARD EXECUTION ---
    if (act.type == ACTION_TYPE.CARD) {
        battle_log = "Player used " + act.data.name + "!";
        p_flash_alpha = 0.8; // VISUAL: Flash Green
        
        // DEBUG: Check the ID in the Output Window
        show_debug_message("USING CARD ID: " + string(act.data.id));

        if (act.data.id == "potion_hyper") {
            // HEALING LOGIC
            var old_hp = act.target.current_hp;
            act.target.current_hp = min(act.target.current_hp + 200, act.target.max_hp);
            var healed_amt = act.target.current_hp - old_hp;
            
            battle_log += " Healed " + string(healed_amt) + " HP!";
        }
        else if (act.data.id == "x_atk") {
            act.target.stats.atk = floor(act.target.stats.atk * 1.5);
            battle_log += " Attack Rose!";
        }
        else if (act.data.id == "x_def") {
             act.target.stats.def = floor(act.target.stats.def * 1.5);
             battle_log += " Defense Rose!";
        }
        else if (act.data.id == "x_spd") {
             act.target.stats.spe = floor(act.target.stats.spe * 1.5);
             battle_log += " Speed Rose!";
        }
    }
    
    // --- ATTACK EXECUTION ---
    else if (act.type == ACTION_TYPE.ATTACK) {
        battle_log = act.actor.nickname + " used " + act.data.name + "!";
        
        // VISUAL: Lunge
        if (act.owner == "PLAYER") p_offset_x = 50; 
        else e_offset_x = -50; 
        
        var result = calculate_damage_gen3(act.actor, act.target, act.data);
        act.target.current_hp = max(0, act.target.current_hp - result.damage);
        
        // VISUAL: Shake & Flash
        if (result.damage > 0) {
            screen_shake = 10;
            if (act.owner == "PLAYER") e_flash_alpha = 1.0; 
            else p_flash_alpha = 1.0;
        }

        battle_log += " Dealt " + string(result.damage) + ". " + result.message;
        
        if (act.target.is_fainted()) {
            state = BATTLE_STATE.CHECK_FAINT;
            action_queue = [];
            exit;
        }
    }
    else if (act.type == ACTION_TYPE.SWITCH) {
        p_active_index = act.data;
        battle_log = "Switched to " + player_team[p_active_index].nickname + "!";
    }
    
    alarm[0] = 120; // Time to read text
} else {
    state = BATTLE_STATE.CHECK_FAINT;
}