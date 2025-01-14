extends Control
class_name Game

@onready var card_holder: CanvasLayer = $CardHolder
@onready var card_half_holder: CanvasLayer = $CardHalfHolder

@onready var hand: Hand = $"Game Container/Play Area/Hand"
@onready var cards_played: CardsPlayed = $"Game Container/Play Area/Cards Played"

@onready var particle_folder: Node2D = $"Particle Folder"
@onready var particle_folder_cv: CanvasLayer = $"Particle Folder CV"

@onready var play_area: Control = $"Game Container/Play Area"

@onready var card_pile_display: CardPileDisplay = $CardPileDisplay

@onready var expedition_complete: VBoxContainer = $"Game Container/Play Area/ExpeditionComplete"
@onready var last_expedition_complete: VBoxContainer = $"Game Container/Play Area/LastExpeditionComplete"
@onready var game_over_display: VBoxContainer = $"Game Container/Play Area/Game Over Display"

@onready var score_requirement_notification: TextureRect = $"Score Requirement/Score Requirement Notification"

@onready var leave_early: Button = $"Game Container/Play Area/Leave Early"

@onready var deck_display_button: Button = $"Game Container/Banner/DeckDisplayButton"

@onready var go_button: Button = $"Game Container/Play Area/ExpeditionComplete/Go"
@onready var victory_button: Button = $"Game Container/Play Area/LastExpeditionComplete/Victory"
@onready var main_menu_button: Button = $"Game Container/Play Area/Game Over Display/HBoxContainer/Main Menu"
@onready var start_over_button: Button = $"Game Container/Play Area/Game Over Display/HBoxContainer/Start Over"

@onready var ore_collected: Control = $"Game Container/Banner/OreCollected"

var game_over_tween: Tween

var expedition_complete_tween: Tween
var expedition_complete_tween_time: float = 0.5

var hand_tween: Tween
var hand_tween_time: float = 1

var score_requirement_tween: Tween
var score_requirement_in_time: = 0.4
var score_requirement_wait_time: = 3.0
var score_requirement_fade_time: = 0.3
var score_requirement_notification_shown: = false

func _ready() -> void :
    Global.card_holder = card_holder
    Global.hand = hand
    Global.cards_played = cards_played
    Global.particle_folder = particle_folder
    Global.particle_folder_cv = particle_folder_cv
    Global.card_half_holder = card_half_holder
    Global.game = self

    SignalBus.ask_to_show_deck.connect(show_deck)
    SignalBus.ask_to_show_draw_pile.connect(show_draw_pile)
    SignalBus.ask_to_show_discard_pile.connect(show_discard_pile)
    card_pile_display.button.pressed.connect(hide_card_pile_display)
    SignalBus.hide_card_pile_display.connect(on_hide_card_pile_display)

    SignalBus.game_over_animation.connect(on_game_over_animation)

    SignalBus.score_requirement_reached.connect(on_score_requirement_reached)

    SignalBus.expedition_started.emit()

    score_requirement_notification.visible = false

func tween_hand_away():
    if hand_tween and hand_tween.is_running(): hand_tween.kill()

    var t: Tween = create_tween()
    t.tween_property(hand, "modulate:a", 0.0, hand_tween_time)

    hand_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
    await hand_tween.tween_property(hand, "position:y", 1200, hand_tween_time)

func on_score_requirement_reached():
    if score_requirement_notification_shown: return


    AudioBus.turn_started.emit()
    score_requirement_notification_shown = true
    score_requirement_notification.visible = true
    score_requirement_notification.scale = Vector2(5, 5)
    if score_requirement_tween and score_requirement_tween.is_running(): score_requirement_tween.kill()
    score_requirement_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    score_requirement_tween.tween_property(score_requirement_notification, "scale", Vector2.ONE, score_requirement_in_time)
    await score_requirement_tween.finished
    await get_tree().create_timer(score_requirement_wait_time, false).timeout
    score_requirement_tween.kill()
    score_requirement_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    score_requirement_tween.tween_property(score_requirement_notification, "scale", Vector2.ZERO, score_requirement_fade_time)
    await score_requirement_tween.finished
    score_requirement_notification.visible = false

func on_game_over_animation():
    if GameLogic.score_collected >= GameLogic.score_required:
        show_expedition_complete()
        return

    show_game_over()

func show_game_over():
    await tween_hand_away()
    await get_tree().create_timer(0.7, false).timeout

    if game_over_tween and game_over_tween.is_running(): game_over_tween.kill()

    game_over_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    game_over_tween.tween_property(game_over_display, "scale", Vector2.ONE, expedition_complete_tween_time)

    await game_over_tween.finished

    AudioBus.game_over.emit()

func show_expedition_complete():
    await tween_hand_away()
    await get_tree().create_timer(0.7, false).timeout

    if GameLogic.expedition_number == GameLogic.EXPEDITIONS_TO_WIN:
        expedition_complete_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
        expedition_complete_tween.tween_property(last_expedition_complete, "scale", Vector2.ONE, expedition_complete_tween_time)
    else:
        expedition_complete_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
        expedition_complete_tween.tween_property(expedition_complete, "scale", Vector2.ONE, expedition_complete_tween_time)

    await get_tree().create_timer(0.1, false).timeout
    AudioBus.expedition_won.emit()

func show_deck():
    get_tree().paused = true
    play_area.visible = false
    card_pile_display.visible = true
    card_holder.visible = false
    particle_folder.visible = false
    particle_folder_cv.visible = false
    card_half_holder.visible = false
    ore_collected.hide_popup()
    card_pile_display.display(DeckManager.deck, "Deck")

func show_draw_pile():
    get_tree().paused = true
    play_area.visible = false
    card_pile_display.visible = true
    card_holder.visible = false
    particle_folder.visible = false
    particle_folder_cv.visible = false
    card_half_holder.visible = false
    ore_collected.hide_popup()
    card_pile_display.display_random(DeckManager.draw_pile, "Draw pile")

func show_discard_pile():
    get_tree().paused = true
    play_area.visible = false
    card_pile_display.visible = true
    card_holder.visible = false
    particle_folder.visible = false
    particle_folder_cv.visible = false
    card_half_holder.visible = false
    ore_collected.hide_popup()
    card_pile_display.display(DeckManager.discard_pile, "Discard pile")

func hide_card_pile_display():
    deck_display_button.showing = false
    get_tree().paused = false
    play_area.visible = true
    card_pile_display.visible = false
    card_holder.visible = true
    particle_folder.visible = true
    particle_folder_cv.visible = true
    card_half_holder.visible = true
    ore_collected.show_popup()

func on_hide_card_pile_display():
    hide_card_pile_display()

func _on_start_over_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_main_menu_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_victory_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_go_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_leave_early_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_go_pressed() -> void :
    go_button.disabled = true
    victory_button.disabled = true
    main_menu_button.disabled = true
    start_over_button.disabled = true
    AudioBus.button_clicked.emit()
    SignalBus.entering_shop.emit()
    LoadingManager.go_to_shop()

func _on_victory_pressed() -> void :
    go_button.disabled = true
    victory_button.disabled = true
    main_menu_button.disabled = true
    start_over_button.disabled = true
    AudioBus.button_clicked.emit()
    LoadingManager.go_to_victory()

func _on_main_menu_pressed() -> void :
    go_button.disabled = true
    victory_button.disabled = true
    main_menu_button.disabled = true
    start_over_button.disabled = true
    AudioBus.button_clicked.emit()
    LoadingManager.go_to_main_menu()

func _on_start_over_pressed() -> void :
    go_button.disabled = true
    victory_button.disabled = true
    main_menu_button.disabled = true
    start_over_button.disabled = true
    AudioBus.button_clicked.emit()
    LoadingManager.go_to_start_over()

func _on_leave_early_pressed() -> void :
    AudioBus.button_clicked.emit()
