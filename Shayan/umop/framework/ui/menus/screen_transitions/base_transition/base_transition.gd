extends CanvasLayer

signal screen_covered

@export var close_duration := 0.3
@export var hide_duration := 0.2
@export var open_duration := 0.3
@export var start_value := 1.0
@export var end_value := 0.0

@onready var color_rect: = $ColorRect
@onready var tween: = $Tween



func _ready() -> void :
	Game.can_pause = false

	tween.interpolate_property(color_rect.get_material(), "shader_param/progress", start_value, end_value, close_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

	await tween.tween_all_completed
	emit_signal("screen_covered")
	await get_tree().create_timer(hide_duration).timeout

	tween.interpolate_property(color_rect.get_material(), "shader_param/progress", end_value, start_value, open_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

	await tween.tween_all_completed
	Game.can_pause = true
	queue_free()
