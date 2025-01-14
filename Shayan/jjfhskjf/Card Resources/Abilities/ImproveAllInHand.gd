extends CardAbility

func play(card: Card):
    var targets: Array = Global.card_holder.get_children()
    if targets.size() == 0: return true

    card.visual.flash()
    card.visual.pop_up_large()

    for target: Card in targets:
        if not target.data.card_type == CardData.card_types.RESOURCE: continue

        target.increase_resource_value(card.data.ability_magnitude)
        StatsTracker.resources_improved += card.data.ability_magnitude
        target.visual.flash_down()
        target.visual.pop_both()



    return true
