if (array_length(action_queue) > 0) {
    var act = action_queue[0];
    array_delete(action_queue, 0, 1);
    
    // --- 1. HANDLE SWITCHING ---
    if (act.type == ACTION_TYPE.SWITCH) {
        p_active_index = act.data;
        battle_log = "Player switched to " + player_team[p_active_index].nickname + "!";
        alarm[0] = 90;
        exit;
    }
    
    // --- 2. VALIDATE ACTOR ---
    // If actor fainted earlier in the turn, they cannot move
    if (act.actor.is_fainted()) {
        battle_log = act.actor.nickname + " fainted and couldn't move!";
        alarm[0] = 60;
        exit;
    }
    
    // --- 3. EXECUTE ATTACKS/CARDS ---
    if (act.type == ACTION_TYPE.CARD) {
        battle_log = "Player used " + act.data.name + "!";
        if (act.data.id == "potion_hyper") {
             act.target.current_hp = min(act.target.current_hp + 200, act.target.max_hp);
             battle_log += " HP Restored.";
        }
        else if (act.data.id == "x_atk") {
            act.target.stats.atk = floor(act.target.stats.atk * 1.5);
            battle_log += " Attack Rose.";
        }
        // Add other cards...
    }
    else if (act.type == ACTION_TYPE.ATTACK) {
        battle_log = act.actor.nickname + " used " + act.data.name + "!";
        
        // Calculate Gen 3 Damage
        var result = calculate_damage_gen3(act.actor, act.target, act.data);
        act.target.current_hp = max(0, act.target.current_hp - result.damage);
        
        // Detailed Logs (Split into 2 messages for readability?)
        // For now, combine them: "Dealt 50 dmg! It's super effective!"
        battle_log += " Dealt " + string(result.damage) + ". " + result.message;
        
        if (act.target.is_fainted()) {
            // Target died, wipe remaining actions targeting them?
            // For now, we let the loop handle it naturally (validation check above handles actor death)
            // But we should stop this specific queue execution to handle faint state
            state = BATTLE_STATE.CHECK_FAINT;
            action_queue = []; // Clear rest of turn
            exit;
        }
    }
    
    alarm[0] = 120; // Wait 2s
} else {
    // End of Turn -> Check Faints
    state = BATTLE_STATE.CHECK_FAINT;
}