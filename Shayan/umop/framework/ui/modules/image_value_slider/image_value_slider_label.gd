extends Label

signal mouse_entered_raw
signal clicked



func _physics_process(_delta: float) -> void :
	if Rect2(Vector2(), size).has_point(get_local_mouse_position()):
		emit_signal("mouse_entered_raw")


func _gui_input(event: InputEvent) -> void :
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("clicked")