extends Node2D

@onready var music: AudioStreamPlayer2D = $Music

var volume: = 0.5

var volume_tween: Tween

func change_volume(value: float):
    volume = clamp(value, 0.0, 1.0)

    for child: AudioStreamPlayer2D in get_children(): child.volume_db = linear_to_db(volume)

func _ready() -> void :
    SignalBus.map_entered.connect(on_map_entered)
    SignalBus.shop_entered.connect(on_shop_entered)

    change_volume(volume)

func on_map_entered():
    if volume_tween and volume_tween.is_running(): volume_tween.kill()
    var volume_tween = create_tween().set_ease(Tween.EASE_OUT)
    volume_tween.tween_method(interpolate_volume, db_to_linear(music.volume_db), volume, 5.0)

func on_shop_entered():
    if volume_tween and volume_tween.is_running(): volume_tween.kill()
    var volume_tween = create_tween().set_ease(Tween.EASE_OUT)
    volume_tween.tween_method(interpolate_volume, db_to_linear(music.volume_db), volume * 0.8, 5.0)

func interpolate_volume(volume_linear: float) -> void :
    music.volume_db = linear_to_db(volume_linear)
