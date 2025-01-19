class_name idle_terry

extends State

func _update(delta):
	if Global.player1.velocity.length() > 0.0:
		transition.emit("advance")
	print(Global.player1.velocity.length())

func _process(delta: float) -> void:
	$"../../model/AnimationPlayer".play("idle")
