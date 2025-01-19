extends LimboState

@export var animation_player : AnimationPlayer
@export var animation_name : StringName
var cool_frames = 0

func _ready() -> void:
	cool_frames = 0

func _update(delta: float) -> void:
	animation_player.play(animation_name)

func end():
	dispatch(&"lpD")
	print("end")
