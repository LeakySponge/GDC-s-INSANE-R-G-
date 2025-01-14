extends Node2D

@export var bounce_duration := 0.1
@export var bounce_height := 5

@onready var tween: = $Tween



func bounce() -> void :
	tween.interpolate_property(self, "position", Vector2(161, 120 - 92 - 6) + Vector2.UP * bounce_height, Vector2(161, 120 - 92 - 6), bounce_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
