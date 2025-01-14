extends Control

func _ready():
    visible = false

func _input(event: InputEvent):
    if event.is_action_pressed("Show Controls"): visible = true
    if event.is_action_released("Show Controls"): visible = false
