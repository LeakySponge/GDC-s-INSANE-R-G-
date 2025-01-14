extends CardAbility

func play(card: Card):
    SignalBus.draw_resources.emit(card.data.ability_magnitude)
    return true
