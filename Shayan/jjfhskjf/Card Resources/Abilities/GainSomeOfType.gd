extends CardAbility

func play(card: Card):
    var target: Card = card.targets[0]
    if not (target.data.card_type == CardData.card_types.RESOURCE or target.data.card_type == CardData.card_types.SCORE):
        card.deselect()
        return false

    if target.data.resource_type == CardData.resource_types.ORE:
        SignalBus.add_ore.emit(card.data.ability_magnitude)
        target.visual.flash_pop()
        return true
    if target.data.resource_type == CardData.resource_types.SCORIUM:
        SignalBus.add_score.emit(card.data.ability_magnitude)
        target.visual.flash_pop()
        return true

func get_score_value_aimed_at(card: Card, card_moused_over: Card) -> int:
    if card_moused_over.data.resource_type == CardData.resource_types.SCORIUM: return card.data.ability_magnitude
    return 0
