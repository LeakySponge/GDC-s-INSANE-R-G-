extends Control

const INSPECT_CARD = preload("res://Card System/inspect_card.tscn")

@onready var grid_container: GridContainer = $ScrollContainer / MarginContainer / GridContainer

func _ready() -> void :
    for child in grid_container.get_children(): child.queue_free()

    for card: CardData in DeckManager.deck:
        var new_card: InspectCard = INSPECT_CARD.instantiate()
        new_card.data = card
        grid_container.add_child(new_card)

func _on_main_menu_pressed():
    AudioBus.button_clicked.emit()
    LoadingManager.go_to_main_menu()

func _on_play_again_pressed():
    AudioBus.button_clicked.emit()
    LoadingManager.go_to_start_over()

func _on_main_menu_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_play_again_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()
