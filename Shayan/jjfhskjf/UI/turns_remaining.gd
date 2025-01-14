extends Control

@onready var counter = $Counter
@onready var last_turn = $"Last Turn"

@onready var label = $Counter / LabelContainer / SubViewport / Label
@onready var label_container = $Counter / LabelContainer

@onready var last_turn_label_container = $"Last Turn/LabelContainer"
@onready var last_turn_label = $"Last Turn/LabelContainer/SubViewport/Label"

var pop_tween: Tween
const pop_tween_size: float = 1.5
const pop_tween_time: float = 0.2

var final_round_flash_counter: int = 0
const final_round_flash_amount: int = 3

func _ready():
    SignalBus.turn_started.connect(update)
    SignalBus.turn_started.connect(pop)
    SignalBus.delve_started.connect(func dummy():
        label.text = "-"
        last_turn.visible = false
        counter.visible = true
    )

func update():
    label.text = str(GameLogic.rounds_remaining)
    if GameLogic.rounds_remaining <= 1:
        last_turn.visible = true
        counter.visible = false
        last_turn_label.set("theme_override_colors/font_color", "d43a2b")
        $FlashTimer.start()
    else:
        last_turn.visible = false
        counter.visible = true

func pop():
    if pop_tween and pop_tween.is_running():
        pop_tween.kill()

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

func _on_flash_timer_timeout():
    if final_round_flash_counter >= final_round_flash_amount:
        $FlashTimer.stop()
        return
    last_turn_label.set("theme_override_colors/font_color", "d43a2b")
    await get_tree().create_timer(0.5, false).timeout
    last_turn_label.set("theme_override_colors/font_color", "f7fff8")
    final_round_flash_counter += 1
