extends CardAbility

func play(card: Card):
    var amount_to_gain = clamp(DeckManager.resources_in_hand(), 0, 99)
    SignalBus.add_energy.emit(amount_to_gain)
    SignalBus.flag_energy_popup.emit(amount_to_gain - card.data.energy_cost)
    return true
