extends CardState

func _ready():
    SignalBus.card_aim_ended.connect(on_aim_ended)

func enter():

    if not CardManager.is_card_selected(): return
    if not CardManager.get_selected_card(): return

    match CardManager.get_selected_card().data.tool_requirements:

        CardData.tool_types.RESOURCES:
            if card.data.card_type == CardData.card_types.RESOURCE:
                transition_requested.emit(self, CardState.State.RECEIVE_AIMING)

        CardData.tool_types.SAW:
            if card.data.card_type == CardData.card_types.RESOURCE and card.data.resource_value > 1:
                transition_requested.emit(self, CardState.State.RECEIVE_AIMING)

        CardData.tool_types.RADAR:
            if card.data.card_type == CardData.card_types.RESOURCE and card.data.resource_value > CardManager.get_selected_card().data.ability_magnitude_2 - 1:
                transition_requested.emit(self, CardState.State.RECEIVE_AIMING)

        CardData.tool_types.WRENCH:
            if card.data.card_type == CardData.card_types.RESOURCE and DeckManager.count_actions_in_play() > 0:
                transition_requested.emit(self, CardState.State.RECEIVE_AIMING)

    transition_requested.emit(self, CardState.State.FADE_AIMING)

func exit():
    pass

func on_aim_ended(_card: Card):
    transition_requested.emit(self, CardState.State.BASE)
