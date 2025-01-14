extends CanvasLayer

@export var OptionsMenu: PackedScene = null
@export var Leaderboard: PackedScene = null

var _secondary_menu = null

@onready var play_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / PlayButton
@onready var leaderboard_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / LeaderboardButton
@onready var options_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / OptionsButton
@onready var quit_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / QuitButton



func _ready() -> void :
	play_button.connect("pressed", Callable(self, "_on_play_button_pressed"))
	leaderboard_button.connect("pressed", Callable(self, "_on_leaderboard_button_pressed"))
	options_button.connect("pressed", Callable(self, "_on_options_button_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_button_pressed"))

	if OS.get_name() == "HTML5":
		quit_button.visible = false



func _spawn_menu(MenuScene: PackedScene) -> void :
	_secondary_menu = MenuScene.instantiate()
	_secondary_menu.connect("closed", Callable(self, "_on_menu_closed"))
	add_child(_secondary_menu)
	$MarginContainer / CenterContainer.visible = false



func _on_play_button_pressed() -> void :
	SceneManager.transition_to_game()


func _on_leaderboard_button_pressed() -> void :
	_spawn_menu(Leaderboard)


func _on_options_button_pressed() -> void :
	_spawn_menu(OptionsMenu)


func _on_quit_button_pressed() -> void :
	Game.quit()


func _on_menu_closed() -> void :
	_secondary_menu.queue_free()
	_secondary_menu = null
	$MarginContainer / CenterContainer.visible = true
