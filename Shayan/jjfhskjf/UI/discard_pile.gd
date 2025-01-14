extends Control

@onready var v_box_container: VBoxContainer = $VBoxContainer

@onready var card_back: TextureRect = $"VBoxContainer/Card Back"
@onready var stack: TextureRect = $VBoxContainer / Stack

@onready var button: TextureButton = $"VBoxContainer/Card Back/Button"

@onready var label: Label = $Label

var pop_tween: Tween
var tween_pop: Tween
var tween_pop_pop_amount: float = 1.2
var tween_pop_pop_time: float = 0.5


const COUNT_BETWEEN_STACKS: = 3


const INIT_SEPARATION: = -66
const INCREMENT: = 6

func _ready() -> void :
    update()

    SignalBus.card_discarded.connect(on_card_discarded)

func on_card_discarded():
    update()

func update():
    label.text = str(DeckManager.discard_pile.size())

    if DeckManager.discard_pile.size() <= 0:
        stack.visible = false
        card_back.visible = false
        return

    stack.visible = true
    card_back.visible = true
    var stack_count = clamp(floor(DeckManager.discard_pile.size() / COUNT_BETWEEN_STACKS), 0, 10)
    v_box_container.set("theme_override_constants/separation", INIT_SEPARATION + (INCREMENT * stack_count))

func _on_button_pressed() -> void :
    SignalBus.ask_to_show_discard_pile.emit()
    AudioBus.button_clicked.emit()

func _on_button_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()
    pop_up()

func _on_button_mouse_exited() -> void :
    pop_down()

func pop_up():
    if tween_pop and tween_pop.is_running(): tween_pop.kill()
    tween_pop = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween_pop.tween_property(button, "scale", Vector2(tween_pop_pop_amount, tween_pop_pop_amount), tween_pop_pop_time)

func pop_down():
    if tween_pop and tween_pop.is_running(): tween_pop.kill()
    tween_pop = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
    tween_pop.tween_property(button, "scale", Vector2.ONE, tween_pop_pop_time)
