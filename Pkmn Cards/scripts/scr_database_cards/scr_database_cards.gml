/// @desc Database of Cards
function get_card_data(_card_id) {
    switch(_card_id) {
        case "potion_hyper":
            return new BattleCard("potion_hyper", "Hyper Potion", "Heals 200 HP", SCOPE.SELF);
            
        case "revive":
            return new BattleCard("revive", "Revive", "Revives fainted mon", SCOPE.SELF);
            
        case "x_atk":
            return new BattleCard("x_atk", "X Attack", "Raises Attack", SCOPE.SELF);
            
        case "x_def":
            return new BattleCard("x_def", "X Defense", "Raises Defense", SCOPE.SELF);
            
        case "x_spd":
            return new BattleCard("x_spd", "X Speed", "Raises Speed", SCOPE.SELF);
    }
    return undefined;
}