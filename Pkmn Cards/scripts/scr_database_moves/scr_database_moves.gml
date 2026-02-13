/// @func get_move_data(_move_id)
function get_move_data(_move_id) {
    switch(_move_id) {
        // FIRE
        case "blaze_kick": return new Move("blaze_kick", "Blaze Kick", ELEMENT.FIRE, 85, 90, 0);
        
        // WATER
        case "surf": return new Move("surf", "Surf", ELEMENT.WATER, 90, 100, 0);
        case "muddy_water": return new Move("muddy_water", "Muddy Water", ELEMENT.WATER, 95, 85, 0);
        
        // GROUND
        case "earthquake": return new Move("earthquake", "Earthquake", ELEMENT.GROUND, 100, 100, 0);
        
        // FIGHTING
        case "sky_uppercut": return new Move("sky_uppercut", "Sky Uppercut", ELEMENT.FIGHTING, 85, 90, 0);
        
        // PSYCHIC
        case "psychic": return new Move("psychic", "Psychic", ELEMENT.PSYCHIC, 90, 100, 0);
        
        // NORMAL/FLYING/DARK
        case "quick_attack": return new Move("quick_attack", "Quick Attack", ELEMENT.NORMAL, 40, 100, 1);
        case "aerial_ace": return new Move("aerial_ace", "Aerial Ace", ELEMENT.FLYING, 60, 200, 0);
        case "tackle": return new Move("tackle", "Tackle", ELEMENT.NORMAL, 40, 100, 0);
        case "bite": return new Move("bite", "Bite", ELEMENT.DARK, 60, 100, 0);

        default:
            show_debug_message("ERROR: Move " + string(_move_id) + " not found.");
            return new Move("struggle", "Struggle", ELEMENT.NORMAL, 50, 100, 0);
    }
}