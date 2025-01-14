extends CardAbility

func play(card: Card):
    DeckManager.discard_to_draw()
    return true
