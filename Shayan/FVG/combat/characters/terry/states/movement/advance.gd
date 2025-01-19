class_name advance

extends State

func update(delta):
	if Global.player.velocity.length() == 0.0:
		transition.emit("idle")

func _process(delta: float) -> void:
	$"../../model/AnimationPlayer".play("advance")
