extends Control
class_name CardPileDisplay

@onready var card_container = $VBoxContainer / ScrollContainer / CenterContainer / MarginContainer / GridContainer
@onready var label = $VBoxContainer / Label
@onready var button = $Button

const INSPECT_CARD = preload("res://Card System/inspect_card.tscn")

func clear():
    for card in card_container.get_children():
        card.queue_free()

func display(card_pile: Array[CardData], message: String):
    clear()

    label.text = message

    for card: CardData in card_pile:
        var new_card: InspectCard = INSPECT_CARD.instantiate()
        new_card.data = card
        card_container.add_child(new_card)

func display_resources(card_pile: Array[CardData], message: String):
    clear()

    label.text = message

    for card: CardData in card_pile:
        var new_card: InspectCard = INSPECT_CARD.instantiate()
        new_card.data = card
        if not card.card_type == CardData.card_types.RESOURCE:
            continue
        card_container.add_child(new_card)













func display_random(card_pile: Array[CardData], message: String):
    clear()

    label.text = message

    var random_order = card_pile.duplicate()
    random_order.shuffle()

    for card: CardData in random_order:
        var new_card: InspectCard = INSPECT_CARD.instantiate()
        new_card.data = card
        card_container.add_child(new_card)

func _on_button_pressed():
    AudioBus.button_clicked.emit()

func _on_button_mouse_entered():
    AudioBus.button_mouse_over.emit()
