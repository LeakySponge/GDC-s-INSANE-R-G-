extends Control
@onready var label: Label = $LabelContainer / SubViewport / Label

@export var small: = false

func _ready() -> void :
    if small:
        label.text = str("expedition ", GameLogic.expedition_number + 1, "/", str(GameLogic.EXPEDITIONS_TO_WIN))
        return

    label.text = str(GameLogic.expedition_number + 1, "/", str(GameLogic.EXPEDITIONS_TO_WIN))
