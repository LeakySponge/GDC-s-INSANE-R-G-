extends CardAbility



func play(card: Card):
    var target: Card = card.targets[0]
    if not target.data.card_type == CardData.card_types.RESOURCE:
        card.deselect()
        return false

    if target.data.resource_value <= 1:
        card.deselect()
        return false

    var amount_reduced = find_reduceable_amount(card, target)
    if amount_reduced == 0: return true

    if target.data.resource_type == CardData.resource_types.ORE:
        target.increase_resource_value( - amount_reduced)
        SignalBus.add_ore.emit(amount_reduced * card.data.ability_magnitude_2)
        target.visual.flash_pop()
        return true
    if target.data.resource_type == CardData.resource_types.SCORIUM:
        target.increase_resource_value( - amount_reduced)
        SignalBus.add_score.emit(amount_reduced * card.data.ability_magnitude_2)
        target.visual.flash_pop()
        return true

    return true

func find_reduceable_amount(card: Card, card_moused_over: Card) -> int:
    var original_amount: = card_moused_over.data.resource_value
    var after_reduction = clamp(original_amount + card.data.ability_magnitude, 1, 99)
    var amount_reduced: int = original_amount - after_reduction
    amount_reduced = clamp(amount_reduced, 1, 99)

    return amount_reduced






func get_score_value_aimed_at(card: Card, card_moused_over: Card) -> int:
    if card_moused_over.data.resource_type == CardData.resource_types.SCORIUM:
        return find_reduceable_amount(card, card_moused_over) * card.data.ability_magnitude_2
    return 0
