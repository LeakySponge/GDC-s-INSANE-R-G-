extends CanvasLayer

var restarting: = false

@onready var hiscore: = $Menu / CenterContainer / VBoxContainer / VBoxContainer / Hiscore
@onready var final_score: = $Menu / CenterContainer / VBoxContainer / VBoxContainer / FinalScore
@onready var restart_button: = $Menu / CenterContainer / VBoxContainer / VBoxContainer / RestartButton
@onready var main_menu_button: = $Menu / CenterContainer / VBoxContainer / VBoxContainer / MainMenuButton
@onready var new_hiscore: = $Menu / CenterContainer / VBoxContainer / VBoxContainer / NewHiscore
@onready var imapct_sound: = $ImpactSound
@onready var restart_sound: = $RestartSound



func _ready() -> void :
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	main_menu_button.connect("pressed", Callable(self, "_on_main_menu_button_pressed"))

	if Game.level._hiscore_done:
		hiscore.hide()
		new_hiscore.show()


func _input(event: InputEvent) -> void :
	if event.is_action_pressed("restart") and not restarting:
		restarting = true
		restart_button.pressed_sound.play_detached()
		Game.restart()
		restart_sound.play_detached()
		imapct_sound.play_detached()



func update_score(score: int) -> void :
	hiscore.text = "HISCORE: %d" % SaveManager.data.hiscore
	final_score.text = "%d" % score



func _on_restart_button_pressed() -> void :
	Game.restart()
	restart_sound.play_detached()
	imapct_sound.play_detached()


func _on_main_menu_button_pressed() -> void :
	SceneManager.transition_to_main_menu()
