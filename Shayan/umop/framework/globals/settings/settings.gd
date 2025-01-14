extends Node

signal fullscreen_changed

var is_fullscreen: = false
var can_screen_shake: = true
var moving_background: = true



func _ready() -> void :
	load_settings()



func toggle_fullscreen() -> void :
	is_fullscreen = not is_fullscreen
	if is_fullscreen:
		get_window().borderless = true
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (true) else Window.MODE_WINDOWED
	else:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (false) else Window.MODE_WINDOWED
		get_window().borderless = false

	save_settings()
	emit_signal("fullscreen_changed")



func save_settings() -> void :
	SaveManager.data.fullscreen = is_fullscreen
	SaveManager.data.screen_shake = can_screen_shake
	SaveManager.save_data()


func load_settings() -> void :
	if is_fullscreen != SaveManager.data.fullscreen:
		toggle_fullscreen()
	can_screen_shake = SaveManager.data.screen_shake
	moving_background = SaveManager.data.moving_background
