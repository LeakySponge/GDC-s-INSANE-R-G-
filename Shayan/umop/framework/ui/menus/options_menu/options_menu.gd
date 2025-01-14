extends CanvasLayer

signal closed

@onready var sfx_slider: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / SFXSlider
@onready var music_slider: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / MusicSlider
@onready var fullscreen_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / FullscreenButton
@onready var screen_shake_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / ScreenShakeButton
@onready var moving_background_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / MovingBackgroundButton
@onready var reset_data_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / ResetDataButton
@onready var back_button: = $MarginContainer / CenterContainer / VBoxContainer / VBoxContainer / BackButton



func _ready() -> void :
	sfx_slider.connect("value_changed", Callable(self, "_on_sfx_slider_value_changed"))
	music_slider.connect("value_changed", Callable(self, "_on_music_slider_value_changed"))
	fullscreen_button.connect("pressed", Callable(self, "_on_fullscreen_button_pressed"))
	screen_shake_button.connect("pressed", Callable(self, "_on_screen_shake_button_pressed"))
	moving_background_button.connect("pressed", Callable(self, "_on_moving_background_button_pressed"))
	reset_data_button.connect("pressed", Callable(self, "_on_reset_data_button_pressed"))
	back_button.connect("pressed", Callable(self, "_on_back_button_pressed"))
	Settings.connect("fullscreen_changed", Callable(self, "_on_Settings_fullscreen_changed"))

	sfx_slider.set_value(AudioBusManager.global_volumes.SFX, false)
	music_slider.set_value(AudioBusManager.global_volumes.Music, false)

	update_fullscreen_button_text()
	update_screen_shake_button_text()
	moving_background_button.text = "ENABLE MOVING BG" if not Settings.moving_background else "DISABLE MOVING BG"

	if OS.get_name() == "HTML5":
		fullscreen_button.hide()


func _unhandled_input(event: InputEvent) -> void :
	if event.is_action_pressed("pause"):
		emit_signal("closed")
		get_viewport().set_input_as_handled()

	if sfx_slider.has_focus():
		if event.is_action_pressed("ui_left"):
			sfx_slider.decrease()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("ui_right"):
			sfx_slider.increase()
			get_viewport().set_input_as_handled()


func update_fullscreen_button_text() -> void :
	fullscreen_button.text = "FULLSCREEN" if not Settings.is_fullscreen else "WINDOWED"


func update_screen_shake_button_text() -> void :
	screen_shake_button.text = "ENABLE SCREEN SHAKE" if not Settings.can_screen_shake else "DISABLE SCREEN SHAKE"



func _on_sfx_slider_value_changed(new_value: int) -> void :
	AudioBusManager.global_volumes.SFX = new_value
	AudioBusManager.set_volume_linear("SFX", sfx_slider.normalized_value)


func _on_music_slider_value_changed(new_value: int) -> void :
	AudioBusManager.global_volumes.Music = new_value
	AudioBusManager.set_volume_linear("Music", music_slider.normalized_value)


func _on_fullscreen_button_pressed() -> void :
	Settings.toggle_fullscreen()


func _on_screen_shake_button_pressed() -> void :
	Settings.can_screen_shake = not Settings.can_screen_shake
	update_screen_shake_button_text()
	Settings.save_settings()


func _on_moving_background_button_pressed() -> void :
	Settings.moving_background = not Settings.moving_background
	moving_background_button.text = "ENABLE MOVING BG" if not Settings.moving_background else "DISABLE MOVING BG"
	Settings.save_settings()



func _on_reset_data_button_pressed() -> void :
	SaveManager.reset_data()


func _on_back_button_pressed() -> void :
	emit_signal("closed")


func _on_Settings_fullscreen_changed() -> void :
	update_fullscreen_button_text()
