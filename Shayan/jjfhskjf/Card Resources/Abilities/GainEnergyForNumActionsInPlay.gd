extends CardAbility

func play(card: Card):
    if DeckManager.count_actions_in_play() >= card.data.ability_magnitude:
        SignalBus.add_energy.emit(card.data.ability_magnitude_2)
        card.data.plus_cards = card.data.ability_magnitude_3
    else:
        card.data.plus_cards = 0


    return true
