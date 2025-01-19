extends LimboState
@export var animation_player : AnimationPlayer
@export var animation_name : StringName

func _update(delta: float) -> void:
	animation_player.play(animation_name)
