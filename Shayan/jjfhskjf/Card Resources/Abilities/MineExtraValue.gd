extends CardAbility

func play(card: Card):
    var target: Card = card.targets[0]
    if not target.data.card_type == CardData.card_types.RESOURCE:
        card.deselect()
        return false

    for i in card.data.ability_magnitude - 1:
        target.add_resource_value()
    target.play(false, true)
    return true

func get_score_value_aimed_at(card: Card, card_moused_over: Card) -> int:
    if card_moused_over.data.resource_type == CardData.resource_types.SCORIUM:
        var score_to_add: = 0
        for i in card.data.ability_magnitude: score_to_add += card_moused_over.data.resource_value
        return score_to_add

    return 0
