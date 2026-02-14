// --------------------------------------------------------
// BATTLE MANAGER - STEP EVENT
// --------------------------------------------------------

switch (state) {
    
case BATTLE_STATE.START:
        // Initial Draw: Only Magic/Traps from Deck
        // Refill logic
        if (array_length(player_deck) < 3) {
            var master = obj_game_data.master_deck_list;
            array_copy(player_deck, 0, master, 0, array_length(master));
            // Shuffle
            var n = array_length(player_deck);
            for (var i = n - 1; i > 0; i--) {
                var j = irandom(i);
                var temp = player_deck[i];
                player_deck[i] = player_deck[j];
                player_deck[j] = temp;
            }
        }
        
        // Draw 3 Starting Cards
        repeat(3) {
             if (array_length(player_deck) > 0) {
                var c = player_deck[0];
                array_delete(player_deck, 0, 1);
                array_push(player_hand, get_card_data(c));
            }
        }
        
        // Spawn Initial Event Card (Heal)
        var heal_pool = ["potion", "potion_super", "heal_par", "heal_psn"];
        event_card_active = get_card_data(heal_pool[irandom(array_length(heal_pool)-1)]);
        
        turn_start_processed = false;
        state = BATTLE_STATE.TURN_START_DECISION;
        break;

    case BATTLE_STATE.TURN_START_DECISION:
        // Turn Start Logic
        if (!turn_start_processed) {
            var p = player_team[p_active_index];
            p.card_buffs = { atk:1.0, def:1.0, spa:1.0, spd:1.0, spe:1.0 }; // Reset temp buffs? Or keep them? 
            // NOTE: If you want cards to last 1 turn only, reset here. If permanent, don't.
            // Prompt said "1-turn temporary effects", so we reset.
            p.recalculate_stats();
            
            // Generate NEW Event Card for this turn
            var heal_pool = ["potion", "potion_super", "potion_hyper", "revive", "heal_brn", "heal_par"];
            // Rare chance for full restore
            if (random(100) < 5) array_push(heal_pool, "full_restore");
            
            event_card_active = get_card_data(heal_pool[irandom(array_length(heal_pool)-1)]);
            battle_log = "Event: " + event_card_active.name + " appeared!";
            
            // Status Dmg logic...
            if (p.status_condition == "BRN" || p.status_condition == "PSN") {
                var dmg = floor(p.max_hp / 8); if (dmg < 1) dmg = 1;
                p.current_hp = max(0, p.current_hp - dmg);
                battle_log += " Hurt by Status!";
            }
            turn_start_processed = true;
        }
        
        if (player_team[p_active_index].is_fainted()) state = BATTLE_STATE.CHECK_FAINT;
        break;
   
    case BATTLE_STATE.DISCARD_CHOICE: break;
    case BATTLE_STATE.INPUT_PHASE: break;
    case BATTLE_STATE.SWITCH_MENU: break;
    case BATTLE_STATE.REVIVE_MENU: break; 

   case BATTLE_STATE.RESOLVE_PHASE:
        // Dim Background for "Cinematic" feel
        if (bg_dim_alpha < 0.6) bg_dim_alpha += 0.05;
   
        turn_start_processed = false;
        action_queue = [];
        var p_mon = player_team[p_active_index];
        var e_mon = enemy_team[e_active_index];
        var card_used = false;

        // 1. SWITCH
        if (selected_switch_target != -1) {
            array_push(action_queue, {
                owner: "PLAYER", actor: p_mon, type: ACTION_TYPE.SWITCH,
                data: selected_switch_target, prio: 10000, spd: 9999
            });
            selected_switch_target = -1; 
        }
        else {
// 2. CARD LOGIC
            // Use selected_card (Index in Hand) OR event_card_active (if special flag set?)
            // We need a way to know if player clicked Hand Card or Event Card.
            // Let's assume selected_card >= 100 means Event Card.
            
            if (selected_card != -1) {
                var card_struct = undefined;
                var is_event = false;
                
                if (selected_card == 100) {
                    card_struct = event_card_active;
                    is_event = true;
                    event_card_active = undefined; // Consumed
                } else {
                    card_struct = player_hand[selected_card];
                }

                // MAGIC / EVENT (Immediate)
                if (card_struct.type == CARD_TYPE.MAGIC || card_struct.type == CARD_TYPE.EVENT) {
                    // Revive Logic
                    if (string_pos("revive", card_struct.id) != 0) {
                         // ... (Keep existing Revive Logic) ...
                         // But use card_struct.id checks
                    } 
                    else {
                        // Standard Card
                        card_anim_active = true; card_anim_timer = 60; card_anim_data = card_struct; card_used = true;
                        
                        var target = (card_struct.target_scope == SCOPE.SELF) ? p_mon : e_mon;
                        
                        array_push(action_queue, {
                            owner: "PLAYER", actor: p_mon, target: target, 
                            type: ACTION_TYPE.CARD, data: card_struct,
                            prio: 2000, spd: 9999
                        });
                    }
                }
                // TRAP (Set)
                else if (card_struct.type == CARD_TYPE.TRAP) {
                    p_mon.active_trap = card_struct;
                    battle_log = "Trap Card Set!";
                    // Traps don't use a turn in YuGiOh usually, but here they assume the "Card Action".
                    // If you want them to be instant and free, remove 'card_used=true'.
                    // For now, let's make setting a trap take the turn.
                    card_used = true; 
                    card_anim_active = true; card_anim_timer = 60; card_anim_data = card_struct;
                }
                
                if (!is_event) array_delete(player_hand, selected_card, 1);
            }
    
            // 3. ATTACK
            if (selected_move != -1) {
                 var m_data = p_mon.moves[selected_move];
                 var p_spd_final = p_mon.stats.spe;
                 if (p_mon.status_condition == "PAR") p_spd_final = -999; 
                 
                 array_push(action_queue, {
                    owner: "PLAYER", actor: p_mon, target: e_mon,
                    type: ACTION_TYPE.ATTACK, data: m_data,
                    prio: m_data.priority, spd: p_spd_final
                });
            }
        }

        // ENEMY ACTION
        var ai_move = e_mon.moves[irandom(array_length(e_mon.moves)-1)];
        var e_spd_final = e_mon.stats.spe;
        if (e_mon.status_condition == "PAR") e_spd_final = -999;

        array_push(action_queue, {
            owner: "ENEMY", actor: e_mon, target: p_mon,
            type: ACTION_TYPE.ATTACK, data: ai_move,
            prio: ai_move.priority, spd: e_spd_final
        });

        // SORT
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
        
        if (card_used) state = BATTLE_STATE.ANIMATION_WAIT;
        else {
            state = BATTLE_STATE.WAIT;
            alarm[0] = 30;
        }
        break;
        
    case BATTLE_STATE.ANIMATION_WAIT:
        if (card_anim_timer > 0) card_anim_timer--;
        else {
            card_anim_active = false;
            state = BATTLE_STATE.WAIT;
            alarm[0] = 10;
        }
        break;

    case BATTLE_STATE.CHECK_FAINT:
        // Reset Dim
        if (bg_dim_alpha > 0) bg_dim_alpha -= 0.05;
    
        var p_mon = player_team[p_active_index];
        var e_mon = enemy_team[e_active_index];
        
        // Enemy Status Damage (End of Turn)
        if (e_mon.status_condition == "BRN" || e_mon.status_condition == "PSN") {
             if (e_mon.current_hp > 0) {
                 var dmg = floor(e_mon.max_hp/8);
                 if(dmg<1) dmg=1;
                 e_mon.current_hp = max(0, e_mon.current_hp - dmg);
                 battle_log = "Enemy hurt by " + e_mon.status_condition;
             }
        }

        if (p_mon.is_fainted()) {
            var alive_count = 0;
            for(var i=0; i<array_length(player_team); i++) if (player_team[i].current_hp > 0) alive_count++;
            
            if (alive_count == 0) {
                battle_log = "You have no Pokémon left! You lost!";
                state = BATTLE_STATE.WIN_LOSS;
            } else {
                battle_log = p_mon.nickname + " fainted! Choose next.";
                // Force switch
                for(var i=0; i<array_length(player_team); i++) {
                    if (player_team[i].current_hp > 0) {
                        p_active_index = i;
                        turn_start_processed = false; // New mon, new turn start logic
                        state = BATTLE_STATE.TURN_START_DECISION;
                        break;
                    }
                }
            }
        }
        else if (e_mon.is_fainted()) {
             battle_log = "Enemy " + e_mon.nickname + " fainted!";
             var found_new = false;
             for(var i=0; i<array_length(enemy_team); i++) {
                 if (enemy_team[i].current_hp > 0) {
                     e_active_index = i;
                     found_new = true;
                     break;
                 }
             }
             if (!found_new) {
                 battle_log = "Enemy has no Pokémon left! You Win!";
                 state = BATTLE_STATE.WIN_LOSS;
             } else {
                 turn_start_processed = false;
                 state = BATTLE_STATE.TURN_START_DECISION;
             }
        }
        else {
            state = BATTLE_STATE.TURN_START_DECISION;
        }
        
        selected_move = -1; selected_card = -1;
        break;
}

// ---------------------------
// VISUAL UPDATES (JUICE)
// ---------------------------
if (state != BATTLE_STATE.RESOLVE_PHASE && bg_dim_alpha > 0) bg_dim_alpha = lerp(bg_dim_alpha, 0, 0.1);

if (screen_shake > 0) screen_shake -= 1;
if (p_flash_alpha > 0) p_flash_alpha -= 0.1;
if (e_flash_alpha > 0) e_flash_alpha -= 0.1;
p_offset_x = lerp(p_offset_x, 0, 0.1);
e_offset_x = lerp(e_offset_x, 0, 0.1);

// TYPEWRITER TEXT LOGIC
var len_curr = string_length(battle_log_display);
var len_targ = string_length(battle_log);

if (battle_log_display != battle_log) {
    if (len_curr < len_targ) {
        // Add 2 characters per frame for speed
        var add_amount = 2;
        battle_log_display += string_copy(battle_log, len_curr + 1, add_amount);
    } else {
        // If display is longer (message changed completely), reset
        battle_log_display = "";
    }
}