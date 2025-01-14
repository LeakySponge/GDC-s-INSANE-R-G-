extends Control

@onready var menu: Control = $Menu
@onready var panel: Panel = $Menu / Panel

@export var enabled = false

var dragging: = false
var pop_tween: Tween

func _ready() -> void :
    visible = false
    menu.pivot_offset = size / 2
    panel.pivot_offset = size / 2

func _input(event: InputEvent) -> void :
    if event.is_action_pressed("Debug Menu") and enabled: visible = not visible

func _physics_process(delta: float) -> void :
    if dragging: global_position = get_global_mouse_position() - pivot_offset

func _on_button_button_down() -> void :
    dragging = true
    pivot_offset = get_global_mouse_position() - global_position
    pop_up_big()
func _on_button_button_up() -> void :
    dragging = false
    pivot_offset = size / 2
    pop_down()

func pop_up():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(menu, "scale", Vector2(1.1, 1.1), 0.5)

func pop_up_big():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(menu, "scale", Vector2(1.2, 1.2), 0.5)

func pop_down():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
    pop_tween.tween_property(menu, "scale", Vector2.ONE, 0.6)


func _on_one_ore_pressed() -> void :
    SignalBus.add_ore.emit(5)
func _on_more_ore_pressed() -> void :
    SignalBus.add_ore.emit(50)

func _on_one_score_pressed() -> void :
    SignalBus.add_score.emit(5)
func _on_more_score_pressed() -> void :
    SignalBus.add_score.emit(50)



func _on_draw_one_pressed() -> void :
    SignalBus.draw_card.emit(1)
func _on_draw_five_pressed() -> void :
    SignalBus.draw_card.emit(5)

func _on_discard_one_pressed() -> void :
    SignalBus.discard_card.emit(1)
func _on_discard_five_pressed() -> void :
    SignalBus.discard_card.emit(5)
func _on_discard_all_pressed() -> void :
    SignalBus.discard_all.emit()



func _on_plus_energy_pressed() -> void :
    SignalBus.add_energy.emit(1)



func _on_win_expo_pressed() -> void :
    SignalBus.add_score.emit(GameLogic.score_required)
    GameLogic.game_over = true
    SignalBus.turn_ended.emit()
    SignalBus.game_over.emit()

func _on_win_game_pressed() -> void :
    GameLogic.expedition_number = GameLogic.EXPEDITIONS_TO_WIN
    SignalBus.add_score.emit(GameLogic.score_required)
    GameLogic.game_over = true
    SignalBus.turn_ended.emit()
    SignalBus.game_over.emit()

func _on_lose_game_pressed() -> void :
    GameLogic.game_over = true
    SignalBus.turn_ended.emit()
    SignalBus.game_over.emit()

func _on_end_turn_pressed() -> void :
    SignalBus.turn_ended.emit()


func _on_start_turn_pressed() -> void :
    pass
func _on_start_expo_pressed() -> void :
    pass
