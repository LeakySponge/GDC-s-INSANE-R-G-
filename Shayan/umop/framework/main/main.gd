extends Node

enum StartScene{SPLASH, MAIN_MENU, GAME}
@export var start_at: StartScene = StartScene.SPLASH



func _ready() -> void :
	if OS.is_debug_build():
		match start_at:
			StartScene.SPLASH:
				SceneManager.transition_to_splash_screen(false)
			StartScene.MAIN_MENU:
				SceneManager.transition_to_main_menu(false)
			StartScene.GAME:
				SceneManager.transition_to_game(false)
	else:
		SceneManager.transition_to_splash_screen(false)
