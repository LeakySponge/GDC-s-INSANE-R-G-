extends CanvasLayer

@onready var options: Control = $Options
@onready var resume_button: Button = $Menu / VBoxContainer / Resume
@onready var start_over_button: Button = $"Menu/VBoxContainer/Start Over"
@onready var main_menu_button: Button = $"Menu/VBoxContainer/Main Menu"
@onready var options_button: Button = $Menu / VBoxContainer / Options

func _ready() -> void :
    visible = false

func _input(event: InputEvent) -> void :
    if event.is_action_pressed("Pause"):
        if not visible: open()
        else:
            close()
            AudioBus.turn_ended.emit()

func open():
    if LoadingManager.loading: return

    get_tree().paused = true
    SignalBus.pause.emit()
    options.close()
    visible = true

    AudioBus.turn_started.emit()

func close():
    if LoadingManager.loading: return

    get_tree().paused = false
    SignalBus.unpause.emit()
    visible = false

func _on_back_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()
func _on_back_pressed() -> void :
    close()
    AudioBus.turn_ended.emit()

func _on_resume_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()
func _on_options_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()
func _on_start_over_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()
func _on_main_menu_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()



func _on_resume_pressed() -> void :
    close()
    AudioBus.button_clicked.emit()

func _on_options_pressed() -> void :
    options.open()
    AudioBus.button_clicked.emit()

func _on_start_over_pressed() -> void :
    main_menu_button.disabled = true
    start_over_button.disabled = true
    resume_button.disabled = true
    options_button.disabled = true

    AudioBus.button_clicked.emit()
    LoadingManager.go_to_start_over()
    await get_tree().create_timer(0.5, true).timeout
    close()

func _on_main_menu_pressed() -> void :
    main_menu_button.disabled = true
    start_over_button.disabled = true
    resume_button.disabled = true
    options_button.disabled = true

    AudioBus.button_clicked.emit()
    LoadingManager.go_to_main_menu()
    await get_tree().create_timer(0.5, true).timeout
    close()
