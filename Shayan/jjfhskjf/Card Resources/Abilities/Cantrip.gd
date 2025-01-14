extends CardAbility

func play(card: Card):
    if card.data.plus_energy > 0:
        SignalBus.add_energy.emit(card.data.plus_energy)
        SignalBus.flag_energy_popup.emit(card.data.plus_energy - card.data.energy_cost)
    if card.data.plus_ore > 0:
        SignalBus.add_ore.emit(card.data.plus_ore)
    if card.data.plus_score > 0:
        SignalBus.add_score.emit(card.data.plus_score)
    if card.data.plus_stored_energy > 0:
        SignalBus.store_energy.emit(card.data.plus_stored_energy)

    return true

func get_score_value(card: Card) -> int:
    return card.data.plus_score
