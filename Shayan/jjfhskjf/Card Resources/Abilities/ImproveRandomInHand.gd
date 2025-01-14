extends CardAbility

func play(card: Card):
    var targets: Array[Card] = DeckManager.get_resources_in_hand()
    if targets.size() == 0: return true

    card.visual.flash()
    card.visual.pop_up_large()

    targets.shuffle()

    for i in clamp(card.data.ability_magnitude_2, 0, targets.size()):
        var target: Card = targets[i]

        target.visual.flash_up_then_down()
        target.increase_resource_value(card.data.ability_magnitude)
        StatsTracker.resources_improved += card.data.ability_magnitude

    return true
