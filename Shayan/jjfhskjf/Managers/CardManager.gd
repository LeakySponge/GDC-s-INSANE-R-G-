extends Node

var selected_card: Card
var dragging_card: Card

func _ready():
    SignalBus.card_selected.connect(card_selected)
    SignalBus.card_deselected.connect(card_deselected)
    SignalBus.card_played.connect(card_played)
    SignalBus.receive_aiming_moused_over.connect(on_receive_aiming_moused_over)
    SignalBus.card_dragged.connect(on_card_dragged)
    SignalBus.card_drag_stopped.connect(on_card_drag_stopped)

func on_card_dragged(card: Card):
    dragging_card = card

func on_card_drag_stopped():
    dragging_card = null

func card_selected(card: Card):

    selected_card = card

func card_deselected(_card: Card):

    selected_card = null

func drag_card(card: Card):
    dragging_card = card

func stop_drag(card: Card):
    dragging_card = null

func card_played(_card: Card):

    selected_card = null

func is_card_selected() -> bool:
    if selected_card: return true
    return false

func is_card_dragging() -> bool:
    if dragging_card: return true
    return false

func get_selected_card() -> Card:
    return selected_card

func get_dragging_card() -> Card:
    return dragging_card

func on_receive_aiming_moused_over(aimed_card: Card):
    if not selected_card: return
    if not aimed_card: return
    if not selected_card.data.ability_1 and not selected_card.data.ability_2: return
    if not aimed_card.data.ability_1 and not aimed_card.data.ability_2: return
    var score_to_display: = 0
    if selected_card.data.ability_1: score_to_display += selected_card.data.ability_1.get_score_value(selected_card)
    if selected_card.data.ability_2: score_to_display += selected_card.data.ability_2.get_score_value(selected_card)
    if aimed_card.data.ability_1: score_to_display += selected_card.data.ability_1.get_score_value_aimed_at(selected_card, aimed_card)
    if aimed_card.data.ability_2: score_to_display += selected_card.data.ability_2.get_score_value_aimed_at(selected_card, aimed_card)
    SignalBus.display_score_on_bar.emit(score_to_display)
