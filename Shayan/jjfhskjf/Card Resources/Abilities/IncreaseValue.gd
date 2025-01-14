extends CardAbility

func play(card: Card):
    var target: Card = card.targets[0]
    if not target.data.card_type == CardData.card_types.RESOURCE:
        card.deselect()
        return false

    target.increase_resource_value(card.data.ability_magnitude)
    StatsTracker.resources_improved += card.data.ability_magnitude
    target.visual.flash_pop()
    return true
