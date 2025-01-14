class_name idle

extends State

func _update(delta):
	if Global.player1.velocity.length() > 0.0:
		transition.emit("advance")
