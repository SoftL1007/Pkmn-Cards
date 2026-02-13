/// @desc RESOLVE ACTIONS (Turn Logic)

if (array_length(action_queue) > 0) {
    // 1. Pop the first action
    var act = action_queue[0];
    array_delete(action_queue, 0, 1);
    
    // 2. Check Faint Interrupt (Stop attacking dead bodies)
    if (act.actor.current_hp <= 0) {
        battle_log = act.actor.nickname + " fainted and cannot move!";
        alarm[0] = 60;
        exit;
    }
    
    // 3. EXECUTE LOGIC
    if (act.type == ACTION_TYPE.CARD) {
        battle_log = "Player used " + act.data.name + "!";
        
        // --- FIXED CARD IDs TO MATCH DATABASE ---
        if (act.data.id == "potion_hyper") {
            act.target.current_hp = min(act.target.current_hp + 200, act.target.max_hp);
            battle_log += " HP Restored.";
        }
        else if (act.data.id == "revive") {
             // Basic stub for revive logic
             battle_log += " (Revive logic stub)";
        }
        else if (act.data.id == "x_atk") {
            act.target.stats.atk = floor(act.target.stats.atk * 1.5);
            battle_log += " Attack Rose.";
        }
        else if (act.data.id == "x_def") {
            act.target.stats.def = floor(act.target.stats.def * 1.5);
            battle_log += " Defense Rose.";
        }
        else if (act.data.id == "x_spd") {
            act.target.stats.spe = floor(act.target.stats.spe * 1.5);
            battle_log += " Speed Rose.";
        }
    }
    else if (act.type == ACTION_TYPE.ATTACK) {
        // Attack Logic
        battle_log = act.actor.nickname + " used " + act.data.name + "!";
        
        var damage = calculate_damage(act.actor, act.target, act.data);
        act.target.current_hp = max(0, act.target.current_hp - damage);
        
        // Append damage info
        // (Wait 1 frame or append immediately? For prototype, append immediately)
        // Note: In a real game, you'd split this into multiple text states.
        
        // Check for Faint
        if (act.target.current_hp <= 0) {
            battle_log = act.target.nickname + " fainted!";
            
            // Clear remaining queue targeting this mon
            // In 1v1, if opponent dies, game over.
            action_queue = []; 
            state = BATTLE_STATE.WIN_LOSS;
            exit;
        } else {
             battle_log = act.actor.nickname + " dealt " + string(damage) + " dmg!";
        }
    }
    
    // 4. Continue Loop
    alarm[0] = 120; // Slower text speed (2 seconds) to read
    
} else {
    // Queue Empty, Turn Over
    if (state != BATTLE_STATE.WIN_LOSS) {
        selected_move = -1;
        selected_card = -1;
        state = BATTLE_STATE.DRAW_PHASE;
    }
}