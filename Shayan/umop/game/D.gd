extends Sprite2D

func _unhandled_input(event):
	if event.is_action_pressed("move_right"):
		get_parent().get_node("PressSound").play_detached()
		frame = 1
		$Key.frame = 1
	elif event.is_action_released("move_right"):
		get_parent().get_node("ReleaseSound").play_detached()
		frame = 0
		$Key.frame = 0