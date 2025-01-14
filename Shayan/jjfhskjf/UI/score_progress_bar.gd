extends Control

@onready var single_digits = $SingleDigits
@onready var double_digits = $DoubleDigits
@onready var triple_digits = $TripleDigits

@onready var single_label: RichTextLabel = $SingleDigits / LabelContainer / SubViewport / Label
@onready var double_label: RichTextLabel = $DoubleDigits / LabelContainer / SubViewport / Label
@onready var triple_label: RichTextLabel = $TripleDigits / LabelContainer / SubViewport / Label

@onready var single_label_container = $SingleDigits / LabelContainer
@onready var double_label_container = $DoubleDigits / LabelContainer
@onready var triple_label_container = $TripleDigits / LabelContainer

@onready var white_bar: TextureProgressBar = $"White Bar"
@onready var yellow_bar: TextureProgressBar = $"Yellow Bar"
@onready var gray_bar: TextureProgressBar = $"Gray Bar"
@onready var progress_timer: Timer = $ProgressTimer
@onready var hide_gray_bar_timer: Timer = $HideGrayBarTimer

@onready var popup_container: SubViewportContainer = $PopupContainer
@onready var popup_label: Label = $PopupContainer / SubViewport / Label
@onready var popup_hang_time: Timer = $"Popup Hang Time"

var pop_tween: Tween
const pop_tween_size: float = 1.5
const pop_tween_time: float = 0.2

var popup_tween: Tween
var popup_tween_size: = 1.7
var popup_tween_hang_time: = 2.0
var popup_tween_animate_time: = 0.3

var stored_amount: = 0

const BAR_MULTIPLIER: = 5.0

func _ready():
    SignalBus.add_score.connect(on_add_score)
    SignalBus.expedition_started.connect(on_expedition_started)
    SignalBus.expedition_won.connect(on_expedition_won)
    SignalBus.display_score_on_bar.connect(on_display_score_on_bar)
    SignalBus.card_moused_off.connect(on_card_moused_off)
    SignalBus.card_played.connect(on_card_played)
    update(0)

    popup_container.visible = false

func on_add_score(amount: int):
    update(amount)
    pop(amount)
    handle_popup(amount)

func on_expedition_started():
    yellow_bar.min_value = 0
    yellow_bar.max_value = GameLogic.score_required * BAR_MULTIPLIER
    yellow_bar.value = 0

    white_bar.min_value = 0
    white_bar.max_value = GameLogic.score_required * BAR_MULTIPLIER
    white_bar.value = 0

    gray_bar.min_value = 0
    gray_bar.max_value = GameLogic.score_required * BAR_MULTIPLIER
    gray_bar.value = 0

    update(0)

func on_expedition_won():
    progress_timer.stop()
    tween_bar()

func update(_amount: int):
    update_bars()
    update_labels()

func update_bars():
    white_bar.value = GameLogic.score_collected * BAR_MULTIPLIER
    progress_timer.start()

func on_display_score_on_bar(amount: int):
    if GameLogic.current_energy <= 0: return
    if GameLogic.score_collected >= GameLogic.score_required: return
    if amount <= 0: return

    gray_bar.value = (GameLogic.score_collected + amount) * BAR_MULTIPLIER
    gray_bar.visible = true
    hide_gray_bar_timer.stop()

    var score_to_display: int = clamp(GameLogic.score_collected + amount, 0, GameLogic.score_required)

    single_label.text = "YELLOW(" + str(score_to_display) + ")" + "/" + str(GameLogic.score_required)
    double_label.text = "YELLOW(" + str(score_to_display) + ")" + "/" + str(GameLogic.score_required)
    triple_label.text = "YELLOW(" + str(score_to_display) + ")" + "/" + str(GameLogic.score_required)

    single_label.text = TextUtilities.center(single_label.text)
    single_label.text = TextUtilities.add_colors(single_label.text)

    double_label.text = TextUtilities.center(double_label.text)
    double_label.text = TextUtilities.add_colors(double_label.text)

    triple_label.text = TextUtilities.center(triple_label.text)
    triple_label.text = TextUtilities.add_colors(triple_label.text)

func on_card_moused_off():
    hide_gray_bar_timer.start()
    update_labels()

func _on_hide_gray_bar_timer_timeout():
    gray_bar.value = 0
    gray_bar.visible = false

func on_card_played(_card: Card):
    pass

func _on_progress_timer_timeout():
    tween_bar()

func tween_bar():
    var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(yellow_bar, "value", GameLogic.score_collected * BAR_MULTIPLIER, 0.2)

func update_labels():
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

    var score_to_display: int = clamp(0, GameLogic.score_required, GameLogic.score_collected)
    single_label.text = "WHITE(" + str(score_to_display) + ")" + "/" + str(GameLogic.score_required)
    double_label.text = "WHITE(" + str(score_to_display) + ")" + "/" + str(GameLogic.score_required)
    triple_label.text = "WHITE(" + str(score_to_display) + ")" + "/" + str(GameLogic.score_required)

    single_label.text = TextUtilities.center(single_label.text)
    single_label.text = TextUtilities.add_colors(single_label.text)

    double_label.text = TextUtilities.center(double_label.text)
    double_label.text = TextUtilities.add_colors(double_label.text)

    triple_label.text = TextUtilities.center(triple_label.text)
    triple_label.text = TextUtilities.add_colors(triple_label.text)

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

func handle_popup(amount: int):
    if amount <= 0: return


    stored_amount += amount

    popup_container.visible = true
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
    popup_container.visible = false
