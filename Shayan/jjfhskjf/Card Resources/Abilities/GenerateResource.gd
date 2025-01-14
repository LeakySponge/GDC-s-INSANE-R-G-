extends CardAbility

func play(card: Card):
    if card.data.resource_type == CardData.resource_types.ORE:
        SignalBus.add_ore.emit(card.data.resource_value)
    elif card.data.resource_type == CardData.resource_types.SCORIUM:
        SignalBus.add_score.emit(card.data.resource_value)
    return true

func get_score_value(card: Card) -> int:
    if card.data.resource_type == CardData.resource_types.SCORIUM: return card.data.resource_value
    else: return 0
