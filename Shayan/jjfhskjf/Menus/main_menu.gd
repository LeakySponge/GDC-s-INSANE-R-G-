extends Control

@onready var options: Control = $Options
@onready var tutorial_button: Button = $Buttons / Tutorial
@onready var tutorial_label: Label = $"Tutorial Label"
@onready var tutorial_button_timer: Timer = $"Tutorial Button Timer"

@onready var play_button: Button = $Buttons / Play

func _ready() -> void :
    options.visible = false
    tutorial_label.visible = false

func _on_play_pressed():
    play_button.disabled = true
    AudioBus.button_clicked.emit()
    GameLogic.start_run()

    if GameLogic.show_tutorial: LoadingManager.go_to_scene("res://Menus/tutorial.tscn", "loading tutorial...", Loader.COLORS.BLUE)
    else: LoadingManager.go_to_scene("res://Map/map.tscn", "starting run...", Loader.COLORS.BLUE)

func _on_tutorial_pressed() -> void :
    AudioBus.button_clicked.emit()
    GameLogic.show_tutorial = true
    tutorial_label.visible = true
    tutorial_label.global_position.y = tutorial_button.global_position.y + 19
    tutorial_button_timer.start()

func _on_about_pressed() -> void :
    AudioBus.button_clicked.emit()
    get_tree().change_scene_to_file("res://Menus/about.tscn")

func _on_options_pressed() -> void :
    AudioBus.button_clicked.emit()
    if options.visible: options.close()
    else: options.open()

func _on_quit_pressed():
    get_tree().quit()
    AudioBus.button_clicked.emit()

func _on_play_mouse_entered():
    AudioBus.button_mouse_over.emit()

func _on_tutorial_mouse_entered():
    AudioBus.button_mouse_over.emit()

func _on_quit_mouse_entered():
    AudioBus.button_mouse_over.emit()

func _on_about_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_options_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_tutorial_button_timer_timeout() -> void :
    tutorial_label.visible = false

func _on_fullscreen_pressed() -> void :
    ResolutionManager.fullscreen()
