extends CardAbility

func play(card: Card):
    if DeckManager.resources_in_hand() <= 0:
        card.data.plus_cards = card.data.ability_magnitude
    else:
        card.data.plus_cards = 0
    return true
