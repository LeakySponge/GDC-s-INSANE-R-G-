extends CanvasLayer
class_name Loader

enum COLORS{BLUE, GREEN}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Text

@onready var green: TextureRect = $Green
@onready var blue: TextureRect = $Blue

var loading: = false

signal finished

func _ready():
    animation_player.play("RESET")

func go_to_scene(scene_path: String, loading_screen_text: String, color: COLORS):
    loading = true

    label.text = loading_screen_text
    label.pivot_offset = Vector2(label.size.x / 2, label.size.y / 2)

    blue.visible = false
    green.visible = false

    match color:
        COLORS.BLUE:
            blue.visible = true
        COLORS.GREEN:
            green.visible = true

    await start()
    get_tree().change_scene_to_file(scene_path)
    get_tree().paused = false
    SignalBus.unpause.emit()
    await finish()

    loading = false

    return

func start():
    animation_player.play("RESET")
    animation_player.play("Start")
    await animation_player.animation_finished

func finish():
    animation_player.play("Finish")
    await animation_player.animation_finished
    finished.emit()

func go_to_main_menu():
    go_to_scene("res://Menus/main_menu.tscn", "loading menu...", Loader.COLORS.BLUE)

func go_to_shop():
    go_to_scene("res://Shop/shop.tscn", "loading shop...", Loader.COLORS.GREEN)

func go_to_victory():
    go_to_scene("res://Menus/victory_screen.tscn", "you won!", Loader.COLORS.BLUE)

func go_to_start_over():
    GameLogic.start_run()
    go_to_scene("res://Map/map.tscn", "starting over...", Loader.COLORS.BLUE)
