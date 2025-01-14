extends CanvasLayer

@export var initial_wait_time := 1.0
@export var final_wait_time := 1.0
@export var fade_duration := 1.0
@export var visible_duration := 3.0

@onready var cover: = $MarginContainer / Cover
@onready var tween: = $Tween
@onready var shake_sound: = $ShakeSound



func _ready() -> void :
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	await get_tree().create_timer(initial_wait_time).timeout

	tween.interpolate_property(cover, "modulate", Color(0, 0, 0, 1), Color(0, 0, 0, 0), fade_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	await tween.tween_all_completed

	
	await get_tree().create_timer(visible_duration).timeout

	tween.interpolate_property(cover, "modulate", Color(0, 0, 0, 0), Color(0, 0, 0, 1), fade_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	await tween.tween_all_completed

	await get_tree().create_timer(final_wait_time).timeout
	SceneManager.transition_to_game()
