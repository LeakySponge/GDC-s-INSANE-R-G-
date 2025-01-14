extends Control

@onready var counter: Control = $Counter
@onready var label: Label = $Counter / LabelContainer / SubViewport / Label
@onready var label_container: Control = $Counter / LabelContainer
@onready var last_turn_label_container: Control = $"Last Turn"
@onready var last_turn_label: Label = $"Last Turn/LabelContainer/SubViewport/Label"

@onready var white_bar: TextureProgressBar = $"White Bar"
@onready var purple_bar: TextureProgressBar = $"Purple Bar"

@onready var progress_timer: Timer = $ProgressTimer

var pop_tween: Tween
const pop_tween_size: float = 1.5
const pop_tween_time: float = 0.2

var final_round_flash_counter: int = 0
const final_round_flash_amount: int = 3

const BAR_MULTIPLIER: = 100.0

func _ready():
    SignalBus.turn_started.connect(update)
    SignalBus.expedition_started.connect(on_expedition_started)
    SignalBus.game_over.connect(on_game_over)

func on_expedition_started():
    purple_bar.min_value = 0
    purple_bar.max_value = (GameLogic.rounds_this_expedition - 1) * BAR_MULTIPLIER
    purple_bar.value = (GameLogic.rounds_this_expedition - 1) * BAR_MULTIPLIER

    white_bar.min_value = 0
    white_bar.max_value = (GameLogic.rounds_this_expedition - 1) * BAR_MULTIPLIER
    white_bar.value = (GameLogic.rounds_this_expedition - 1) * BAR_MULTIPLIER

    label.text = ""
    last_turn_label_container.visible = false
    counter.visible = true

    update()

func on_game_over():
    last_turn_label_container.visible = false
    white_bar.value = 0
    await get_tree().create_timer(0.5, false).timeout
    var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(purple_bar, "value", 0, 0.15)

func update():
    purple_bar.value = (GameLogic.rounds_remaining - 1) * BAR_MULTIPLIER
    progress_timer.start()

    if GameLogic.rounds_remaining <= 1: await show_last()

    last_turn_label_container.visible = false
    counter.visible = true

    label.text = str(clamp(GameLogic.rounds_remaining - 1, 0, 99))

    if GameLogic.rounds_remaining >= GameLogic.rounds_this_expedition: return
    if GameLogic.rounds_remaining <= 1: return

    pop()

func _on_progress_timer_timeout():
    tween_bar()

func tween_bar():
    var tween: Tween = create_tween().set_ease(Tween.EASE_OUT)
    tween.tween_property(white_bar, "value", purple_bar.value, 0.15)

func show_last():
    if GameLogic.is_game_over(): return
    last_turn_label_container.visible = true
    counter.visible = false
    AudioBus.caves_collapse_warning.emit()
    pop()
    for i in 5:
        last_turn_label.set("theme_override_colors/font_color", "d43a2b")
        await get_tree().create_timer(0.5, false).timeout
        last_turn_label.set("theme_override_colors/font_color", "f7fff8")
        await get_tree().create_timer(0.5, false).timeout
        if i == 4: await get_tree().create_timer(0.5, false).timeout

func pop():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()

    pop_tween = create_tween().set_parallel(true)
    pop_tween.set_ease(Tween.EASE_OUT)
    pop_tween.set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(label_container, "scale", Vector2(pop_tween_size, pop_tween_size), pop_tween_time)
    pop_tween.tween_property(last_turn_label_container, "scale", Vector2(pop_tween_size, pop_tween_size), pop_tween_time)
    await pop_tween.finished
    pop_tween.stop()
    pop_tween = create_tween().set_parallel(true)
    pop_tween.set_ease(Tween.EASE_IN)
    pop_tween.set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(label_container, "scale", Vector2.ONE, pop_tween_time)
    pop_tween.tween_property(last_turn_label_container, "scale", Vector2.ONE, pop_tween_time)
