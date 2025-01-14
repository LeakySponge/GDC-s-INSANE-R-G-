extends Node

var level = null
var camera = null
var player = null
var can_pause: = true

var using_joystick: = false



func _ready():
	if not OS.is_debug_build():
		get_window().always_on_top = (false)

	randomize()


func _input(event: InputEvent) -> void :
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		using_joystick = true
	elif event is InputEventKey:
		using_joystick = false

	if event.is_action_pressed("quit_game") and OS.is_debug_build():
		quit()
	elif event.is_action_pressed("fullscreen_toggle") and OS.get_name() != "HTML5":
		Settings.toggle_fullscreen()



func restart() -> void :
	get_tree().paused = false
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Game"), 0, false)
	SceneManager.transition_to_game()


func quit() -> void :
	if OS.get_name() != "HTML5":
		get_tree().quit()


func add_to_level(node: Node) -> void :
	level.add_child(node)


func freeze(seconds: float) -> void :
	get_tree().paused = true
	await get_tree().create_timer(seconds).timeout
	get_tree().paused = false
