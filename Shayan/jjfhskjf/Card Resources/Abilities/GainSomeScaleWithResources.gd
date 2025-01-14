extends CardAbility

func play(card: Card):
    var target: Card = card.targets[0]
    if not (target.data.card_type == CardData.card_types.RESOURCE or target.data.card_type == CardData.card_types.SCORE):
        card.deselect()
        return false

    var amount_to_gain = clamp(card.data.ability_magnitude + (DeckManager.resources_in_deck() * card.data.ability_magnitude_2), card.data.ability_magnitude_3, 999)

    if target.data.resource_type == CardData.resource_types.ORE:
        SignalBus.add_ore.emit(amount_to_gain)
        target.visual.flash_pop()
        return true
    if target.data.resource_type == CardData.resource_types.SCORIUM:
        SignalBus.add_score.emit(amount_to_gain)
        target.visual.flash_pop()
        return true

func get_score_value_aimed_at(card: Card, card_moused_over: Card) -> int:
    var amount_to_gain = clamp(card.data.ability_magnitude + (DeckManager.resources_in_deck() * card.data.ability_magnitude_2), card.data.ability_magnitude_3, 999)
    if card_moused_over.data.resource_type == CardData.resource_types.SCORIUM: return amount_to_gain
    return 0
