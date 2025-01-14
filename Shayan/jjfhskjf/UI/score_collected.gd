extends Control

@onready var single_digits = $SingleDigits
@onready var double_digits = $DoubleDigits
@onready var triple_digits = $TripleDigits

@onready var single_label: Label = $SingleDigits / LabelContainer / SubViewport / Label
@onready var double_label: Label = $DoubleDigits / LabelContainer / SubViewport / Label
@onready var triple_label: Label = $TripleDigits / LabelContainer / SubViewport / Label

@onready var single_label_container = $SingleDigits / LabelContainer
@onready var double_label_container = $DoubleDigits / LabelContainer
@onready var triple_label_container = $TripleDigits / LabelContainer


var pop_tween: Tween
const pop_tween_size: float = 1.5
const pop_tween_time: float = 0.2

func _ready():
    SignalBus.add_score.connect(update)
    SignalBus.add_score.connect(pop)
    SignalBus.delve_started.connect(on_delve_started)
    update(0)

func on_delve_started():
    update(0)

func update(_amount: int):
    if GameLogic.score_required >= 100:
        triple_digits.visible = true
        double_digits.visible = false
        single_digits.visible = false
    elif GameLogic.score_required >= 10:
        triple_digits.visible = false
        double_digits.visible = true
        single_digits.visible = false
    else:
        triple_digits.visible = false
        double_digits.visible = false
        single_digits.visible = true

    single_label.text = str(GameLogic.score_collected) + "/" + str(GameLogic.score_required)
    double_label.text = str(GameLogic.score_collected) + "/" + str(GameLogic.score_required)
    triple_label.text = str(GameLogic.score_collected) + "/" + str(GameLogic.score_required)

func pop(_amount: int):
    if pop_tween and pop_tween.is_running():
        pop_tween.kill()

    pop_tween = create_tween().set_parallel(true)
    pop_tween.set_ease(Tween.EASE_OUT)
    pop_tween.set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(single_label_container, "scale", Vector2(pop_tween_size, pop_tween_size), pop_tween_time)
    pop_tween.tween_property(double_label_container, "scale", Vector2(pop_tween_size, pop_tween_size), pop_tween_time)
    pop_tween.tween_property(triple_label_container, "scale", Vector2(pop_tween_size, pop_tween_size), pop_tween_time)
    await pop_tween.finished
    pop_tween.stop()
    pop_tween = create_tween().set_parallel(true)
    pop_tween.set_ease(Tween.EASE_IN)
    pop_tween.set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(single_label_container, "scale", Vector2.ONE, pop_tween_time)
    pop_tween.tween_property(double_label_container, "scale", Vector2.ONE, pop_tween_time)
    pop_tween.tween_property(triple_label_container, "scale", Vector2.ONE, pop_tween_time)
