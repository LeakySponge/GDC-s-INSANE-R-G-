extends Node

const EXPEDITIONS_TO_WIN: = 15

var expedition_number: int = 0

var rounds_this_expedition: int = 5
var rounds_remaining: int

var ore_collected: int = 0

var current_energy: int = 0
var stored_energy: int = 0

var energy_each_turn: int = 3

var score_collected: int = 0
var score_required: int = 3

var cards_to_draw: int = 5

const initial_shop_card_upgrade_cost: int = 3
var shop_card_upgrade_cost: int = initial_shop_card_upgrade_cost
const shop_card_upgrade_amount: int = 2
const shop_card_upgrade_cost_increase: int = 4

const initial_shop_card_removal_cost: int = 10
var shop_card_removal_cost: int = initial_shop_card_removal_cost
const shop_card_removal_cost_increase: int = 25


const shop_inflation_flat_increase: float = 0.4
const shop_inflation_scaling: float = 0.1

var game_over: = false
var expedition_won: = false
var in_shop: = false
var show_tutorial: = false

var total_ore_mined: = 0
var total_score_mined: = 0

func _ready():
    SignalBus.add_ore.connect(add_ore)
    SignalBus.add_score.connect(add_score)

    SignalBus.add_energy.connect(add_energy)
    SignalBus.subtract_energy.connect(subtract_energy)
    SignalBus.store_energy.connect(on_store_energy)

    SignalBus.expedition_started.connect(on_expedition_started)

    SignalBus.turn_started.connect(on_turn_started)
    SignalBus.turn_ended.connect(on_turn_ended)

    SignalBus.shop_entered.connect(on_shop_entered)



func start_run():
    game_over = false
    expedition_won = false
    in_shop = false

    expedition_number = 0
    ore_collected = 0
    score_collected = 0

    shop_card_upgrade_cost = initial_shop_card_upgrade_cost
    shop_card_removal_cost = initial_shop_card_removal_cost

    SignalBus.run_started.emit()

func is_game_over() -> bool:
    return game_over

func is_expedition_won() -> bool:
    return expedition_won

func add_ore(amount: int):
    GameLogic.ore_collected += amount
    StatsTracker.ore_mined += amount

func add_score(amount: int):
    GameLogic.score_collected += amount
    StatsTracker.score_collected += amount

    if score_collected >= score_required:
        await get_tree().create_timer(0.2, false).timeout
        SignalBus.score_requirement_reached.emit()






func add_energy(amount: int):
    current_energy += amount
    current_energy = clamp(current_energy, 0, 99)
    SignalBus.energy_changed.emit()
    SignalBus.energy_added.emit()

func subtract_energy(amount: int):
    current_energy -= amount
    StatsTracker.energy_spent += amount
    current_energy = clamp(current_energy, 0, 99)
    SignalBus.energy_changed.emit()
    SignalBus.energy_subtracted.emit()

func on_store_energy(amount: int):
    stored_energy += amount
    stored_energy = clamp(stored_energy, 0, 99)

func refresh_energy():
    if game_over or expedition_won: return
    current_energy = energy_each_turn
    current_energy += stored_energy
    SignalBus.flag_energy_popup.emit(stored_energy)
    current_energy = clamp(current_energy, 0, 99)
    stored_energy = 0
    SignalBus.energy_changed.emit()
    SignalBus.energy_refreshed.emit()









func set_difficulty():
    match expedition_number:
        1:
            score_required = 6
            rounds_this_expedition = 4
        2:
            score_required = 10
            rounds_this_expedition = 4
        3:
            score_required = 15
            rounds_this_expedition = 4


        4:
            score_required = 18
            rounds_this_expedition = 4
        5:
            score_required = 24
            rounds_this_expedition = 4
        6:
            score_required = 35
            rounds_this_expedition = 4


        7:
            score_required = 40
            rounds_this_expedition = 5
        8:
            score_required = 60
            rounds_this_expedition = 5
        9:
            score_required = 90
            rounds_this_expedition = 5


        10:
            score_required = 95
            rounds_this_expedition = 5
        11:
            score_required = 120
            rounds_this_expedition = 5
        12:
            score_required = 170
            rounds_this_expedition = 5


        13:
            score_required = 190
            rounds_this_expedition = 6
        14:
            score_required = 240
            rounds_this_expedition = 6
        15:
            score_required = 300
            rounds_this_expedition = 6











































    rounds_remaining = rounds_this_expedition



func check_game_over():
    if GameLogic.rounds_remaining <= 0:
        game_over = true
        SignalBus.game_over.emit()

func on_turn_started():
    refresh_energy()

func on_turn_ended():
    current_energy = 0
    rounds_remaining -= 1

    check_game_over()

func on_expedition_started():
    expedition_number += 1
    score_collected = 0
    stored_energy = 0

    expedition_won = false
    in_shop = false

    set_difficulty()

func on_shop_entered():
    stored_energy = 0
    game_over = false
    in_shop = true
    refresh_energy()
