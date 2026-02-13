switch (state) {
    
    // --- PHASE 1: DRAW CARDS ---
    case BATTLE_STATE.DRAW_PHASE:

    
    // RNG Healing Check
    if (array_length(player_hand) < max_hand_size && random(100) < 15) {
        array_push(player_hand, get_card_data("potion_hyper")); // USE DB FUNCTION
        battle_log = "A Hyper Potion appeared!";
    } 
    else if (array_length(player_hand) < max_hand_size && array_length(player_deck) > 0) {
        var card_id = player_deck[0];
        array_delete(player_deck, 0, 1);
        
        // USE DB FUNCTION
        var new_card = get_card_data(card_id);
        array_push(player_hand, new_card);
    }
        
        state = BATTLE_STATE.INPUT_PHASE;
        break;

    // --- PHASE 2: PLAYER INPUT ---
    case BATTLE_STATE.INPUT_PHASE:
        // Handled by UI buttons setting variables.
        // Waiting for user to click "GO"
        break;

    // --- PHASE 3: RESOLUTION SETUP ---
    case BATTLE_STATE.RESOLVE_PHASE:
        action_queue = [];
        
        // 1. Add Player Actions
        // Card (Priority 1000 - always first)
        if (selected_card != -1) {
            array_push(action_queue, {
                owner: "PLAYER",
                actor: player_pokemon,
                target: player_pokemon, // Most cards are self
                type: ACTION_TYPE.CARD,
                data: player_hand[selected_card],
                prio: 1000,
                spd: 9999
            });
            // Remove card from hand
            array_delete(player_hand, selected_card, 1);
        }
        
        // Move (Priority based on move data)
        if (selected_move != -1) {
            var move_data = player_pokemon.moves[selected_move];
            array_push(action_queue, {
                owner: "PLAYER",
                actor: player_pokemon,
                target: enemy_pokemon,
                type: ACTION_TYPE.ATTACK,
                data: move_data,
                prio: move_data.priority,
                spd: player_pokemon.stats.spe
            });
        }
        
        // 2. Add Enemy Actions (Basic AI: Random Move)
        var ai_move_idx = irandom(array_length(enemy_pokemon.moves) - 1);
        var ai_move = enemy_pokemon.moves[ai_move_idx];
        
        array_push(action_queue, {
            owner: "ENEMY",
            actor: enemy_pokemon,
            target: player_pokemon,
            type: ACTION_TYPE.ATTACK,
            data: ai_move,
            prio: ai_move.priority,
            spd: enemy_pokemon.stats.spe
        });
        
        // 3. Sort Queue (Bubble sort for clarity)
        // Order: Priority Descending -> Speed Descending
        var len = array_length(action_queue);
        for (var i = 0; i < len - 1; i++) {
            for (var j = 0; j < len - i - 1; j++) {
                var a = action_queue[j];
                var b = action_queue[j+1];
                
                var swap = false;
                if (b.prio > a.prio) swap = true;
                else if (b.prio == a.prio && b.spd > a.spd) swap = true;
                
                if (swap) {
                    var temp = action_queue[j];
                    action_queue[j] = action_queue[j+1];
                    action_queue[j+1] = temp;
                }
            }
        }
        
        // Start executing actions one by one
        state = BATTLE_STATE.WAIT;
        alarm[0] = 30; // 0.5s delay before first action
        break;
}