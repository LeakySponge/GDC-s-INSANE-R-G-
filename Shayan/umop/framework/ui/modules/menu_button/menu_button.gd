extends Button

@onready var pressed_sound: = $PressedSound
@onready var hover_sound: = $HoverSound



func _ready() -> void :
	connect("mouse_entered", Callable(self, "_on_button_mouse_entered"))
	connect("button_down", Callable(self, "_on_button_down"))

	custom_minimum_size.x = size.x + 6




func _on_button_mouse_entered() -> void :
	hover_sound.play_detached()


func _on_button_down() -> void :
	pressed_sound.play_detached()


func _on_MenuButton_focus_entered():
	hover_sound.play_detached()
