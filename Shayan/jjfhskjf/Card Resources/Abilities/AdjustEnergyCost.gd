extends CardAbility

func play(card: Card):
    var target: Card = card.targets[0]
    if not target.data.card_type == CardData.card_types.RESOURCE:
        card.deselect()
        return false

    target.adjust_energy_cost(card.data.ability_magnitude_2)
    target.visual.flash_pop()
    return true
