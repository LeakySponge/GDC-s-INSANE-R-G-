extends CardAbility

func play(card: Card):
    card.data.plus_cards = DeckManager.resources_in_hand()
    return true
