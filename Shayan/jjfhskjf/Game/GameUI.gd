extends Control

@onready var hand: HBoxContainer = $"Game Container/Play Area/Hand"
@onready var play_area = $"Game Container/Play Area"

@onready var ore_collected = $"Game Container/Play Area/OreCollected"

@onready var end_turn: TextureButton = $"Game Container/Play Area/End Turn"
@onready var expedition_complete = $"Game Container/Play Area/ExpeditionComplete"
@onready var game_over = $"Game Container/Play Area/GameOver"
@onready var last_expedition_complete = $"Game Container/Play Area/LastExpeditionComplete"
@onready var energy_indicator = $"Game Container/Play Area/EnergyIndicator"
@onready var draw_pile_indicator = $"Game Container/Play Area/MarginContainer/DrawPileIndicator"
@onready var discard_pile_indicator = $"Game Container/Play Area/MarginContainer/DiscardPileIndicator"
@onready var card_pile_display = $CardPileDisplay

var score_font_tween: Tween
var score_font_tween_2: Tween

var hand_tween: Tween
var hand_tween_time: float = 1

var expedition_complete_tween: Tween
var game_over_tween: Tween
var expedition_complete_tween_time: float = 0.5

var wait_for_end_tween_time: float = 0.7

var player_deck: CardPile
var player_turn: bool = false

const hand_shrink_size: int = 5
const hand_max_amount: int = 9
const hand_default_separation: int = 70
const decrease_hand_separation: int = -25

const CARD = preload("res://Card System/card.tscn")

func _ready():
    GameLogic.game_ui = self

    SignalBus.delve_started.emit()
    SignalBus.expedition_won.connect(on_expedition_victory)
    SignalBus.turn_started.connect(on_turn_started)
    SignalBus.turn_ended.connect(on_turn_ended)
    SignalBus.draw_card.connect(draw_card)
    SignalBus.game_over.connect(on_game_over)
    SignalBus.card_played.connect(on_card_played)
    SignalBus.draw_cards.connect(draw_cards)

    SignalBus.ask_to_show_deck.connect(show_deck)
    SignalBus.ask_to_show_draw_pile.connect(show_draw_pile)
    SignalBus.ask_to_show_discard_pile.connect(show_discard_pile)
    card_pile_display.button.pressed.connect(hide_card_pile_display)

    SignalBus.end_of_turn_discards.connect(draw_initial_cards)

    draw_initial_cards()

func on_expedition_victory():
    end_turn.disabled = true
    if GameLogic.expedition_number == 10:
        show_victory()
    else:
        show_expedition_complete()

    await tween_hand_away()

    for card: Card in hand.get_children():
        GameLogic.discard(card)
        card.free()

func show_victory():

    await get_tree().create_timer(wait_for_end_tween_time, false).timeout

    if expedition_complete_tween and expedition_complete_tween.is_running():
        expedition_complete_tween.kill()

    expedition_complete_tween = create_tween()
    expedition_complete_tween.set_ease(Tween.EASE_IN_OUT)
    expedition_complete_tween.set_trans(Tween.TRANS_CUBIC)
    expedition_complete_tween.tween_property(last_expedition_complete, "scale", Vector2.ONE, expedition_complete_tween_time)

    await get_tree().create_timer(0.1, false).timeout
    AudioBus.expedition_won.emit()

func show_expedition_complete():
    await get_tree().create_timer(wait_for_end_tween_time, false).timeout

    if expedition_complete_tween and expedition_complete_tween.is_running():
        expedition_complete_tween.kill()

    expedition_complete_tween = create_tween()
    expedition_complete_tween.set_ease(Tween.EASE_IN_OUT)
    expedition_complete_tween.set_trans(Tween.TRANS_CUBIC)
    expedition_complete_tween.tween_property(expedition_complete, "scale", Vector2.ONE, expedition_complete_tween_time)

    await get_tree().create_timer(0.1, false).timeout
    AudioBus.expedition_won.emit()

func tween_hand_away():
    if hand_tween and hand_tween.is_running():
        hand_tween.kill()

    hand_tween = create_tween().set_parallel(true)
    hand_tween.set_ease(Tween.EASE_IN)
    hand_tween.set_trans(Tween.TRANS_CUBIC)
    hand_tween.tween_property(hand, "position:y", 1000, hand_tween_time)

    hand_tween.tween_property(end_turn, "position:y", 1450, hand_tween_time)
    hand_tween.tween_property(energy_indicator, "position:y", 1450, hand_tween_time)
    hand_tween.tween_property(discard_pile_indicator, "position:y", 1450, hand_tween_time)
    hand_tween.tween_property(draw_pile_indicator, "position:y", 1450, hand_tween_time)

    await hand_tween.finished

func draw_card():
    if GameLogic.is_game_over(): return
    var card_to_draw: CardData = GameLogic.draw_pile.pop_front()

    if hand.get_children().size() >= hand_max_amount:
        SignalBus.max_cards_in_hand_reached.emit()
        return

    var new_card: Card = CARD.instantiate()
    new_card.data = card_to_draw
    hand.add_child(new_card)
    update_hand_scale()
    AudioBus.card_drawn.emit()
    SignalBus.card_drawn.emit()

func draw_cards(amount: int):
    if GameLogic.is_game_over(): return
    await get_tree().create_timer(0.2, false).timeout
    for i in amount:
        if hand.get_children().size() >= hand_max_amount: return

        if GameLogic.draw_pile.size() == 0:
            GameLogic.discard_to_draw()
            if GameLogic.draw_pile.size() == 0: return
        draw_card()
        await get_tree().create_timer(0.2, false).timeout

func draw_initial_cards():
    await GameLogic.check_game_over()
    if GameLogic.is_game_over(): return
    await draw_cards(GameLogic.cards_to_draw)
    SignalBus.turn_started.emit()

func on_turn_started():
    end_turn.disabled = false
    draw_pile_indicator.button.disabled = false
    discard_pile_indicator.button.disabled = false
    if GameLogic.rounds_remaining <= 1:
        AudioBus.caves_collapse_warning.emit()
    else:
        AudioBus.turn_started.emit()

func on_turn_ended():
    AudioBus.turn_ended.emit()
    await discard_hand()
    SignalBus.end_of_turn_discards.emit()

func on_card_played(card: Card):
    update_hand_scale()

func discard_hand():

    for card: Card in hand.get_children():
        GameLogic.discard(card)
        card.free()
        AudioBus.card_discarded.emit()
        await get_tree().create_timer(0.1, false).timeout

func on_game_over():
    end_turn.disabled = true
    draw_pile_indicator.button.disabled = true
    discard_pile_indicator.button.disabled = true
    tween_hand_away()

    await get_tree().create_timer(wait_for_end_tween_time, false).timeout
    if game_over_tween and game_over_tween.is_running():
        game_over_tween.kill()

    game_over_tween = create_tween()
    game_over_tween.set_ease(Tween.EASE_IN)
    game_over_tween.set_trans(Tween.TRANS_EXPO)
    game_over_tween.tween_property(game_over, "scale", Vector2.ONE, expedition_complete_tween_time)

    await game_over_tween.finished

    AudioBus.game_over.emit()

func _on_end_turn_pressed():
    end_turn.disabled = true
    draw_pile_indicator.button.disabled = true
    discard_pile_indicator.button.disabled = true
    end_turn.release_focus()
    if not GameLogic.is_player_turn(): return
    SignalBus.turn_ended.emit()

func _on_go_pressed():
    AudioBus.button_clicked.emit()
    SignalBus.entering_shop.emit()
    get_tree().change_scene_to_file("res://Shop/shop.tscn")

func _on_start_over_pressed():
    AudioBus.button_clicked.emit()
    GameLogic.start_run()

func _on_victory_pressed():
    AudioBus.button_clicked.emit()
    get_tree().change_scene_to_file("res://Menus/victory_screen.tscn")

func update_hand_scale():
    var cards_in_hand: int = hand.get_children().size()

    if cards_in_hand > hand_shrink_size:
        hand.set("theme_override_constants/separation", hand_default_separation + (decrease_hand_separation * (cards_in_hand - 5)))
    else:
        hand.set("theme_override_constants/separation", hand_default_separation)

func show_deck():
    get_tree().paused = true
    play_area.visible = false
    card_pile_display.visible = true
    card_pile_display.display(GameLogic.deck, "Deck")

func show_draw_pile():
    get_tree().paused = true
    play_area.visible = false
    card_pile_display.visible = true
    card_pile_display.display_random(GameLogic.draw_pile, "Draw pile (order randomized)")

func show_discard_pile():
    get_tree().paused = true
    play_area.visible = false
    card_pile_display.visible = true
    card_pile_display.display(GameLogic.discard_pile, "Discard pile")

func hide_card_pile_display():
    get_tree().paused = false
    play_area.visible = true
    card_pile_display.visible = false

func _on_go_mouse_entered():
    AudioBus.button_mouse_over.emit()

func _on_victory_mouse_entered():
    AudioBus.button_mouse_over.emit()

func _on_start_over_mouse_entered():
    AudioBus.button_mouse_over.emit()

func _on_end_turn_mouse_entered():
    if end_turn.disabled: return
    AudioBus.button_mouse_over.emit()

func _on_main_menu_mouse_entered():
    AudioBus.button_mouse_over.emit()

func _on_main_menu_pressed():
    AudioBus.button_clicked.emit()
    get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
