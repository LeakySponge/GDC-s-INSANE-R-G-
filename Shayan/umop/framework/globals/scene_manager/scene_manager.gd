extends Node

@export var screen_transition: PackedScene
@export var levels # (Array, PackedScene)
@export var splash_screen: PackedScene
@export var main_menu: PackedScene
@export var game: PackedScene

var transitioning: = false

var _current_level: = 0



func transition_to_splash_screen(transition = true) -> void :
	transition_to_scene(splash_screen.resource_path, transition)


func transition_to_game(transition = true) -> void :
	transition_to_scene(game.resource_path, transition)


func transition_to_main_menu(transition = true) -> void :
	transition_to_scene(main_menu.resource_path, transition)


func change_to_level(level: int, transition = true) -> void :
	_current_level = level % levels.size()
	transition_to_scene(levels[_current_level].resource_path, transition)


func next_level(transition = true) -> void :
	change_to_level(_current_level + 1, transition)


func restart_level(transition = true) -> void :
	change_to_level(_current_level, transition)


func transition_to_scene(path: String, transition = true) -> void :
	if transition:
		var wipe = screen_transition.instantiate()
		add_child(wipe)
		await wipe.screen_covered
	get_tree().change_scene_to_file(path)
