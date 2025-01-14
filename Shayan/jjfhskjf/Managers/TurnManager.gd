extends Node

var player_turn: = false
var player_input: = false



func _ready() -> void :
    SignalBus.turn_started.connect(on_turn_started)
    SignalBus.turn_ended.connect(on_turn_ended)
    SignalBus.expedition_started.connect(on_expedition_started)
    SignalBus.end_of_turn_discards.connect(on_end_of_turn_discards)

func is_player_turn():
    return player_turn

func is_player_input_allowed():
    return player_input

func start_turn():
    player_turn = true
    player_input = true
    SignalBus.turn_started.emit()

func end_turn():
    player_turn = false
    player_input = false

func on_turn_started():
    pass

func on_turn_ended():
    end_turn()

func on_expedition_started():
    await get_tree().create_timer(0.9, false).timeout
    start_turn()

func on_end_of_turn_discards():
    start_turn()
