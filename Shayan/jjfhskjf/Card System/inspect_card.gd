extends Control
class_name InspectCard

@export var data: CardData

@onready var visual: CardVisual = $CardVisual

var is_moused_over: = false

var locked: = false

func _ready() -> void :
    if data:
        visual.data = data
        visual.create_visual()
        visual.label_white()

func lock():
    locked = true

func self_destruct():
    await get_tree().create_timer(5.0, false).timeout
    queue_free()

func initialize(data: CardData):
    visual.data = data
    visual.create_visual()
    visual.label_white()
    visual.hide_stamp()

func _physics_process(delta: float) -> void :
    if locked:
        visual.rotate_idle()
        return

    if is_moused_over: visual.rotate()
    else: visual.rotate_idle()

func _on_button_gui_input(event: InputEvent) -> void :
    if locked: return

    if event.is_action_pressed("Click"):
        SignalBus.card_inspected.emit(data)

func _on_button_mouse_entered() -> void :
    if locked: return

    is_moused_over = true
    AudioBus.card_moused_over.emit()
    visual.z_index += 1
    visual.pop_up()

func _on_button_mouse_exited() -> void :
    if locked: return

    is_moused_over = false
    visual.z_index -= 1
    visual.pop_down()
