extends Node2D

const base: Vector2 = Vector2(320, 180)
const upscale_factor: int = 6

var resolution: Vector2
var scaling: int

func _ready():

    resolution = Vector2(DisplayServer.window_get_size())
    scaling = (resolution / base).x

    fullscreen()

func increase():
    scaling += 1
    resolution += base

    check_fullscreen()

    DisplayServer.window_set_size(resolution)
    get_window().position -= Vector2i(base / 2)

    SignalBus.resolution_changed.emit()

func decrease():
    if scaling <= 1:
        return

    scaling -= 1
    resolution -= base

    check_fullscreen()

    DisplayServer.window_set_size(resolution)
    get_window().position += Vector2i(base / 2)

    SignalBus.resolution_changed.emit()

func windowed():
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func fullscreen():
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
    resolution = Vector2(get_viewport_rect().size)
    scaling = (resolution / base).x

func borderless():
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    resolution = Vector2(get_viewport_rect().size)
    scaling = (resolution / base).x

func check_fullscreen():
    if resolution == Vector2(DisplayServer.screen_get_size()):
        borderless()
    else:
        windowed()
