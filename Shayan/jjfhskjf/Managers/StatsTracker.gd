extends Node

var ore_mined: = 0
var ore_spent: = 0

var score_collected: = 0

var resources_improved: = 0

var turns_taken: = 0
var energy_spent: = 0

var cards_played: = 0
var cards_drawn: = 0
var cards_discarded: = 0

var resources_played: = 0
var actions_played: = 0
var tools_played: = 0
var utilities_bought: = 0
var hammers_bought: = 0
var dynamite_bought: = 0

var times_rerolled: = 0

func _ready() -> void :
    SignalBus.run_started.connect(on_run_started)

func on_run_started():
    ore_mined = 0
    ore_spent = 0
    score_collected = 0
    resources_improved = 0
    turns_taken = 0
    energy_spent = 0
    cards_played = 0
    cards_drawn = 0
    cards_discarded = 0
    resources_played = 0
    actions_played = 0
    tools_played = 0
    utilities_bought = 0
    hammers_bought = 0
    dynamite_bought = 0
    times_rerolled = 0
