/// @desc Database of all Moves
function get_move_data(_move_id) {
    switch(_move_id) {
        // --- FIRE ---
        case "blaze_kick": 
            // Name, Type, Power, Acc, Cat, Priority
            return new Move("blaze_kick", "Blaze Kick", ELEMENT.FIRE, 85, 90, "SPECIAL", 0);
        
        // --- FIGHTING ---
        case "sky_uppercut":
            return new Move("sky_uppercut", "Sky Uppercut", ELEMENT.FIGHTING, 85, 90, "PHYSICAL", 0);
            
        // --- WATER ---
        case "surf":
            return new Move("surf", "Surf", ELEMENT.WATER, 90, 100, "SPECIAL", 0);
        case "muddy_water":
             return new Move("muddy_water", "Muddy Water", ELEMENT.WATER, 95, 85, "SPECIAL", 0);
            
        // --- GROUND ---
        case "earthquake":
            return new Move("earthquake", "Earthquake", ELEMENT.GROUND, 100, 100, "PHYSICAL", 0);
            
        // --- GRASS ---
        case "leaf_blade":
            return new Move("leaf_blade", "Leaf Blade", ELEMENT.GRASS, 70, 100, "SPECIAL", 0); // Gen 3 Grass = Special
            
        // --- PSYCHIC ---
        case "psychic":
            return new Move("psychic", "Psychic", ELEMENT.PSYCHIC, 90, 100, "SPECIAL", 0);
            
        // --- NORMAL ---
        case "tackle":
            return new Move("tackle", "Tackle", ELEMENT.NORMAL, 40, 100, "PHYSICAL", 0);
        case "quick_attack":
            return new Move("quick_attack", "Quick Attack", ELEMENT.NORMAL, 40, 100, "PHYSICAL", 1);
            
        // --- DARK ---
        case "bite":
            return new Move("bite", "Bite", ELEMENT.DARK, 60, 100, "SPECIAL", 0); // Gen 3 Dark = Special
            
        // --- FLYING ---
        case "aerial_ace":
            return new Move("aerial_ace", "Aerial Ace", ELEMENT.FLYING, 60, 200, "PHYSICAL", 0);
            
        default:
            show_debug_message("Error: Move " + _move_id + " not found.");
            return new Move("struggle", "Struggle", ELEMENT.NONE, 50, 100, "PHYSICAL", 0);
    }
}