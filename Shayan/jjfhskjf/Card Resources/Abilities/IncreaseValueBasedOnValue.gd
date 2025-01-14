extends CardAbility

func play(card: Card):
    var target: Card = card.targets[0]
    if not target.data.card_type == CardData.card_types.RESOURCE:
        card.deselect()
        return false

    var improvement_amount: = 0
    improvement_amount = floor(target.data.resource_value / card.data.ability_magnitude_2)
    improvement_amount = clamp(improvement_amount, 0, card.data.ability_magnitude_3)
    target.increase_resource_value(improvement_amount)
    StatsTracker.resources_improved += improvement_amount
    target.visual.flash_pop()
    return true
