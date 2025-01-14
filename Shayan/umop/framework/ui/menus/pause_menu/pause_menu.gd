extends CanvasLayer

signal unpaused

@export var OptionsMenu: PackedScene = null

var _options_menu = null

@onready var resume_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / ResumeButton
@onready var restart_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / RestartButton
@onready var options_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / OptionsButton
@onready var main_menu_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / MainMenuButton
@onready var quit_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / QuitButton
@onready var pause_sound: = $PauseSound
@onready var unpause_sound: = $UnpauseSound
@onready var imapct_sound: = $ImpactSound
@onready var restart_sound: = $RestartSound



func _ready() -> void :
	resume_button.connect("pressed", Callable(self, "_on_resume_button_pressed"))
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	options_button.connect("pressed", Callable(self, "_on_options_button_pressed"))
	main_menu_button.connect("pressed", Callable(self, "_on_main_menu_button_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_button_pressed"))

	get_tree().paused = true
	pause_sound.play_detached()

	resume_button.grab_focus()

	if OS.get_name() == "HTML5":
		quit_button.hide()


func _unhandled_input(event: InputEvent) -> void :
	if event.is_action_pressed("pause") and Game.can_pause:
		unpause()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("restart"):
		
		restart_sound.play_detached()
		get_tree().paused = false
		SceneManager.transition_to_game()
		imapct_sound.play_detached()



func unpause() -> void :
	unpause_sound.play_detached()
	emit_signal("unpaused")
	get_tree().paused = false
	queue_free()



func _on_resume_button_pressed() -> void :
	unpause()


func _on_restart_button_pressed() -> void :
	get_tree().paused = false
	imapct_sound.play_detached()
	restart_sound.play_detached()
	SceneManager.transition_to_game()


func _on_options_button_pressed() -> void :
	_options_menu = OptionsMenu.instantiate()
	_options_menu.connect("closed", Callable(self, "_on_options_menu_closed"))
	add_child(_options_menu)
	$MarginContainer / CenterContainer.visible = false


func _on_main_menu_button_pressed() -> void :
	emit_signal("unpaused")
	get_tree().paused = false
	SceneManager.transition_to_main_menu()


func _on_options_menu_closed() -> void :
	_options_menu.queue_free()
	_options_menu = null
	$MarginContainer / CenterContainer.visible = true


func _on_quit_button_pressed():
	Game.quit()
