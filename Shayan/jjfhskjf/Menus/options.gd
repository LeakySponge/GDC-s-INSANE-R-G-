extends Control

@onready var back: Button = $Back

@onready var sound_slider: HSlider = $"Sliders/Sounds/Sound Slider"
@onready var music_slider: HSlider = $"Sliders/Music/Music Slider"
@onready var ambience_slider: HSlider = $"Sliders/Ambience/Ambience Slider"

func open():
    visible = true
    back.disabled = false

    sound_slider.value = AudioBus.volume
    music_slider.value = MusicBus.volume
    ambience_slider.value = AmbienceBus.volume

func close():
    visible = false
    back.disabled = true

func _on_back_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_back_pressed() -> void :
    visible = false
    back.disabled = true
    AudioBus.button_clicked.emit()

func _on_up_mouse_entered():
    AudioBus.button_mouse_over.emit()
func _on_up_pressed():
    ResolutionManager.increase()
    AudioBus.button_clicked.emit()
func _on_down_mouse_entered():
    AudioBus.button_mouse_over.emit()
func _on_down_pressed():
    ResolutionManager.decrease()
    AudioBus.button_clicked.emit()


func _on_sound_slider_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_music_slider_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_ambience_slider_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_sound_slider_drag_ended(value_changed: bool) -> void :
    sound_slider.release_focus()
    AudioBus.card_discarded.emit()

func _on_music_slider_drag_ended(value_changed: bool) -> void :
    music_slider.release_focus()
    AudioBus.card_discarded.emit()

func _on_ambience_slider_drag_ended(value_changed: bool) -> void :
    ambience_slider.release_focus()
    AudioBus.card_discarded.emit()

func _on_sound_slider_drag_started() -> void :
    AudioBus.card_drawn.emit()

func _on_music_slider_drag_started() -> void :
    AudioBus.card_drawn.emit()

func _on_ambience_slider_drag_started() -> void :
    AudioBus.card_drawn.emit()


func _on_sound_slider_value_changed(value: float) -> void :
    AudioBus.change_volume(sound_slider.value)

func _on_music_slider_value_changed(value: float) -> void :
    MusicBus.change_volume(music_slider.value)

func _on_ambience_slider_value_changed(value: float) -> void :
    AmbienceBus.change_volume(ambience_slider.value)
