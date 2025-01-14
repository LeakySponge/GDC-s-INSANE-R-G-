extends CardAbility

func play(card: Card):
    var target: Card = card.targets[0]
    if not target.data.card_type == CardData.card_types.RESOURCE:
        card.deselect()
        return false

    SignalBus.add_ore.emit(target.data.resource_value)
    target.play(false, true)
    return true

func get_score_value_aimed_at(card: Card, card_moused_over: Card) -> int:
    if card_moused_over.data.resource_type == CardData.resource_types.SCORIUM:
        return card_moused_over.data.resource_value

    return 0
