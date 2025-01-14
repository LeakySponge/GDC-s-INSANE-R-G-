extends Control

@onready var label = $LabelContainer / SubViewport / Label
@onready var label_container = $LabelContainer

@onready var popup_container: SubViewportContainer = $PopupContainer
@onready var popup_label: Label = $PopupContainer / SubViewport / Label
@onready var popup_hang_time: Timer = $"Popup Hang Time"

var pop_tween: Tween
const pop_tween_size: float = 0.25
const pop_tween_time: float = 0.2

var popup_tween: Tween
var popup_tween_size: = 1.7
var popup_tween_hang_time: = 2.0
var popup_tween_animate_time: = 0.3

var stored_amount: = 0

func _ready():
    SignalBus.add_ore.connect(on_ore_added)
    SignalBus.add_ore.connect(pop)
    SignalBus.ore_spent.connect(on_ore_spent)
    update(0)
    popup_container.scale = Vector2.ZERO

func hide_popup():
    popup_container.visible = false

func show_popup():
    popup_container.visible = true

func on_ore_added(amount: int):
    update(amount)
    handle_popup(amount)

func handle_popup(amount: int):
    if amount <= 0: return

    stored_amount += amount
    popup_label.text = str("+", stored_amount, "!")

    popup_up()
    popup_hang_time.start()

func popup_up():
    popup_container.scale = Vector2.ZERO
    if popup_tween and popup_tween.is_running(): popup_tween.kill()
    popup_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    popup_tween.tween_property(popup_container, "scale", Vector2(popup_tween_size, popup_tween_size), popup_tween_animate_time)
    popup_tween.tween_property(popup_container, "scale", Vector2.ONE, popup_tween_animate_time)

func popup_down():
    if popup_tween and popup_tween.is_running(): popup_tween.kill()
    popup_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    popup_tween.tween_property(popup_container, "scale", Vector2.ZERO, popup_tween_animate_time)
    await popup_tween.finished

func _on_popup_hang_time_timeout() -> void :
    stored_amount = 0
    await popup_down()

func on_ore_spent():
    update(0)

func update(_amount: int):
    label.text = str(GameLogic.ore_collected)

func pop(_amount: int):
    label_container.pivot_offset.x = 192 / 8
    if GameLogic.ore_collected >= 10: label_container.pivot_offset.x = 192 / 4
    if pop_tween and pop_tween.is_running():
        pop_tween.kill()

    pop_tween = create_tween()
    pop_tween.set_ease(Tween.EASE_OUT)
    pop_tween.set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(label_container, "scale", Vector2((1 + pop_tween_size), (1 + pop_tween_size)), pop_tween_time)
    await pop_tween.finished
    pop_tween.stop()
    pop_tween = create_tween()
    pop_tween.set_ease(Tween.EASE_IN)
    pop_tween.set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(label_container, "scale", Vector2.ONE, pop_tween_time)
