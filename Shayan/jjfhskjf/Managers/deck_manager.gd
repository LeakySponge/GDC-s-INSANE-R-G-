extends Node

const CARD_PARTICLE = preload("res://Particles/card_particle.tscn")

@export var starting_deck: Array[CardData]

@onready var deck: Array[CardData] = []
@onready var draw_pile: Array[CardData] = []
@onready var discard_pile: Array[CardData] = []

const CARDS_PER_TURN: = 5

const DRAW_WAIT_TIME: = 0.25
const DISCARD_WAIT_TIME: = 0.15
const DISCARD_TO_DRAW_WAIT_TIME: = 0.1
const DISCARD_TIME_DIVISOR: = 0.97
const DISCARD_TIME_MIN: = 0.05
const DISCARD_TIME_MAX: = 0.25

var shuffling: = false
var initial_hand_drawn: = false

signal finished_shuffling

func _ready() -> void :
    initialize()

    SignalBus.card_played.connect(card_played)

    SignalBus.draw_card.connect(on_draw_card)
    SignalBus.discard_card.connect(on_discard_card)
    SignalBus.discard_all.connect(on_discard_all)

    SignalBus.draw_resources.connect(on_draw_resources)

    SignalBus.run_started.connect(on_run_started)
    SignalBus.expedition_started.connect(on_expedition_started)

    SignalBus.turn_started.connect(on_turn_started)
    SignalBus.turn_ended.connect(on_turn_ended)

    SignalBus.card_purchased.connect(on_card_purchased)
    SignalBus.add_card.connect(on_card_added)
    SignalBus.add_to_draw_pile.connect(on_add_to_draw_pile)

    SignalBus.expedition_won.connect(on_expedition_won)
    SignalBus.game_over.connect(on_game_over)

    SignalBus.shop_entered.connect(on_shop_entered)

func on_run_started():
    initialize()

func on_expedition_started():
    initial_hand_drawn = false

    for card in deck:
        draw_pile.append(card)

    shuffle()

func _physics_process(delta: float) -> void :
    pass

func initialize():
    deck.clear()
    draw_pile.clear()
    discard_pile.clear()

    for card in starting_deck: deck.append(card.duplicate())

func print_deck():
    print("###############")
    print("Printing deck:")
    for card: CardData in deck:
        print(card.name)
    print("###############")

func shuffle():
    draw_pile.shuffle()

func resources_in_draw_pile() -> int:
    if draw_pile.size() <= 0: return 0

    var count: = 0
    for data: CardData in draw_pile:
        if data.card_type == CardData.card_types.RESOURCE: count += 1
    return count

func resources_in_deck() -> int:
    if deck.size() <= 0: return 0

    var count: = 0
    for data: CardData in deck:
        if data.card_type == CardData.card_types.RESOURCE: count += 1
    return count

func resources_in_hand() -> int:
    if not Global.hand: return 0
    if Global.hand.slots.get_children().size() <= 0: return 0

    var count: = 0
    for slot: CardSlot in Global.hand.slots.get_children():
        if slot.held_card.data.card_type == CardData.card_types.RESOURCE: count += 1
    return count

func get_resources_in_hand() -> Array[Card]:
    if not Global.hand: return []
    if Global.hand.slots.get_children().size() <= 0: return []

    var array_to_return: Array[Card] = []
    for slot: CardSlot in Global.hand.slots.get_children():
        if slot.held_card.data.card_type == CardData.card_types.RESOURCE: array_to_return.append(slot.held_card)
    return array_to_return

func get_cards_in_play() -> Array[CardData]:
    if not Global.cards_played: return []
    if Global.cards_played.slots.get_children().size() <= 0: return []

    var array_to_return: Array[CardData] = []
    for slot: CardSlot in Global.cards_played.slots.get_children():
        array_to_return.append(slot.held_half.data)
    return array_to_return

func count_cards_in_play():
    return get_cards_in_play().size()

func count_resources_in_play():
    var count: = 0
    for data: CardData in get_cards_in_play():
        if data.card_type == CardData.card_types.RESOURCE: count += 1
    return count

func count_actions_in_play():
    var count: = 0
    for data: CardData in get_cards_in_play():
        if data.card_type == CardData.card_types.ACTION: count += 1
    return count

func count_tools_in_play():
    var count: = 0
    for data: CardData in get_cards_in_play():
        if data.card_type == CardData.card_types.TARGET: count += 1
    return count

func on_draw_card(amount: int):
    draw_cards(amount)

func on_discard_card(amount: int):
    discard_cards(amount)

func on_discard_all():
    discard_all()

func draw():
    if GameLogic.is_game_over() or GameLogic.is_expedition_won(): return
    if draw_pile.size() <= 0: await discard_to_draw()
    if draw_pile.size() <= 0 and discard_pile.size() <= 0: return
    if not TurnManager.is_player_turn(): return
    if not Global.hand: return

    StatsTracker.cards_drawn += 1
    Global.hand.draw(draw_pile.pop_front())
    SignalBus.card_drawn.emit()
    AudioBus.card_drawn.emit()

func discard():
    if GameLogic.is_expedition_won(): return
    if Global.hand.slots.get_children().size() <= 0: return

    discard_pile.append(Global.hand.discard())
    StatsTracker.cards_discarded += 1
    SignalBus.card_discarded.emit()
    AudioBus.card_discarded.emit()

func draw_cards(amount: int):
    if amount == 0: return
    if draw_pile.size() <= 0: await discard_to_draw()
    if draw_pile.size() <= 0 and discard_pile.size() <= 0: return



    if shuffling:
        await finished_shuffling
        await get_tree().create_timer(randf_range(0.0, 1.0), false).timeout

    for i in amount:
        await draw()
        await get_tree().create_timer(DRAW_WAIT_TIME, false).timeout

func discard_cards(amount: int):
    if amount == 0: return

    var FINAL_WAIT_TIME: = DISCARD_WAIT_TIME
    for i in Global.hand.slots.get_children().size(): FINAL_WAIT_TIME *= DISCARD_TIME_DIVISOR
    FINAL_WAIT_TIME = clamp(FINAL_WAIT_TIME, DISCARD_TIME_MIN, DISCARD_TIME_MAX)

    for i in amount:
        discard()
        await get_tree().create_timer(FINAL_WAIT_TIME, false).timeout

func discard_all():
    await discard_cards(Global.hand.slots.get_children().size())

func discard_to_draw():
    if discard_pile.size() <= 0: return
    if GameLogic.is_game_over(): return

    shuffling = true

    var FINAL_WAIT_TIME: = DISCARD_WAIT_TIME
    for i in discard_pile.size(): FINAL_WAIT_TIME *= DISCARD_TIME_DIVISOR
    FINAL_WAIT_TIME = clamp(FINAL_WAIT_TIME, DISCARD_TIME_MIN, DISCARD_TIME_MAX)

    for i in discard_pile.size():
        spawn_card_particle()
        await get_tree().create_timer(FINAL_WAIT_TIME, false).timeout
        draw_pile.append(discard_pile.pop_front())
        SignalBus.card_drawn.emit()
        SignalBus.card_discarded.emit()
        AudioBus.reshuffle.emit()

    SignalBus.card_discarded.emit()
    shuffle()

    shuffling = false
    finished_shuffling.emit()

func on_draw_resources(amount: int):
    var count = 0
    var first_resources: Array[CardData] = []

    for data: CardData in draw_pile:
        if data.card_type == CardData.card_types.RESOURCE and count < amount:
            first_resources.append(data)
            count += 1

    for data: CardData in draw_pile:
        if not first_resources.has(data): first_resources.append(data)

    draw_pile = first_resources

    draw_cards(clamp(resources_in_draw_pile(), 0, amount))

func move_resource_to_front():
    pass

func spawn_card_particle():
    Global.particle_folder.add_child(CARD_PARTICLE.instantiate())

func clear_played_cards():
    var slots = Global.cards_played.slots.get_children()
    slots.reverse()

    var FINAL_WAIT_TIME: = DISCARD_WAIT_TIME
    for i in Global.cards_played.slots.get_children().size(): FINAL_WAIT_TIME *= DISCARD_TIME_DIVISOR

    for slot: CardSlot in slots:
        var cleared_data: CardData = slot.clear()
        if not cleared_data.consumable: discard_pile.append(cleared_data)
        SignalBus.card_discarded.emit()
        AudioBus.card_discarded.emit()
        await get_tree().create_timer(FINAL_WAIT_TIME, false).timeout

func card_played(card: Card):
    pass

func add_card(data: CardData):
    deck.append(data)

    SignalBus.deck_changed.emit()

func on_card_added(data: CardData):
    add_card(data)

func on_add_to_draw_pile(data: CardData):
    draw_pile.append(data)

    SignalBus.card_drawn.emit()

func on_card_purchased(data: CardData):
    deck.append(data)
    GameLogic.ore_collected -= data.final_price

    StatsTracker.ore_spent += data.final_price
    SignalBus.ore_spent.emit()
    SignalBus.deck_changed.emit()

func on_turn_started():
    await draw_cards(CARDS_PER_TURN)
    SignalBus.start_of_turn_draws.emit()

    initial_hand_drawn = true

func on_turn_ended():
    await clear_played_cards()
    await get_tree().create_timer(DISCARD_TO_DRAW_WAIT_TIME * 1.5, false).timeout
    await discard_all()
    if GameLogic.is_game_over(): SignalBus.game_over_animation.emit()
    SignalBus.end_of_turn_discards.emit()

func on_expedition_won():
    pass

func on_game_over():
    pass



func on_shop_entered():
    draw_pile.clear()
    discard_pile.clear()
