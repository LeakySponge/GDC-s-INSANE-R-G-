extends Control

@onready var indicator: Control = $Indicator
@onready var art: TextureRect = $Indicator / Art
@onready var label_container: SubViewportContainer = $Indicator / LabelContainer
@onready var label: Label = $Indicator / LabelContainer / SubViewport / Label

@onready var popup_container: SubViewportContainer = $PopupContainer
@onready var popup_label: Label = $PopupContainer / SubViewport / Label

const ENERGY_INDICATOR_SQUARE = preload("res://Art/EnergyIndicatorSquare.png")
const ENERGY_INDICATOR_SQUARE_EMPTY = preload("res://Art/EnergyIndicatorSquareEmpty.png")

var pop_tween: Tween
var tween_pop: Tween
var tween_pop_pop_amount: float = 1.1
var tween_pop_pop_time: float = 0.1

var tween_pop_pop_big: float = 1.15
var tween_pop_pop_big_time: float = 0.15

var initial_pop: = false

var popup_tween: Tween
var popup_tween_size: = 1.4
var popup_tween_hang_time: = 2.0
var popup_tween_animate_time: = 0.25

var stored_amount: = 0

func _ready():
    SignalBus.energy_changed.connect(update)
    SignalBus.energy_added.connect(pop)
    SignalBus.energy_subtracted.connect(pop)
    SignalBus.energy_refreshed.connect(pop_big)
    SignalBus.flag_energy_popup.connect(on_flag_energy_popup)

    popup_container.visible = false

func on_flag_energy_popup(amount: int):
    if amount <= 0: return

    stored_amount += amount

    popup_container.visible = true
    popup_label.text = str("+", stored_amount, "!")

    popup_container.scale = Vector2.ZERO

    await popup_animation()

    stored_amount = 0
    popup_container.visible = false

func popup_animation():
    if popup_tween and popup_tween.is_running(): popup_tween.kill()
    popup_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    popup_tween.tween_property(popup_container, "scale", Vector2(popup_tween_size, popup_tween_size), popup_tween_animate_time)
    popup_tween.tween_property(popup_container, "scale", Vector2.ONE, popup_tween_animate_time)
    await get_tree().create_timer(popup_tween_hang_time, false).timeout
    popup_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    popup_tween.tween_property(popup_container, "scale", Vector2.ZERO, popup_tween_animate_time)
    await popup_tween.finished

func update():
    if GameLogic.current_energy <= 0:
        art.texture = ENERGY_INDICATOR_SQUARE_EMPTY
    else:
        art.texture = ENERGY_INDICATOR_SQUARE

    label.text = str(GameLogic.current_energy)

func pop():
    if GameLogic.is_expedition_won() or GameLogic.is_game_over(): return

    if tween_pop and tween_pop.is_running():
        tween_pop.kill()
    tween_pop = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween_pop.tween_property(indicator, "scale", Vector2(tween_pop_pop_amount, tween_pop_pop_amount), tween_pop_pop_time)
    await tween_pop.finished
    tween_pop = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
    tween_pop.tween_property(indicator, "scale", Vector2.ONE, tween_pop_pop_time)

func pop_big():
    if GameLogic.is_expedition_won() or GameLogic.is_game_over(): return

    if not initial_pop:
        initial_pop = true
        return

    if tween_pop and tween_pop.is_running():
        tween_pop.kill()
    tween_pop = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween_pop.tween_property(indicator, "scale", Vector2(tween_pop_pop_big, tween_pop_pop_big), tween_pop_pop_big_time)
    await tween_pop.finished
    tween_pop = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
    tween_pop.tween_property(indicator, "scale", Vector2.ONE, tween_pop_pop_big_time)
