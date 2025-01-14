extends Control

func _ready() -> void :
    GameLogic.show_tutorial = false
    SignalBus.tutorial_finished.connect(on_tutorial_finished)

func on_tutorial_finished(): LoadingManager.go_to_scene("res://Map/map.tscn", "starting run...", Loader.COLORS.BLUE)
