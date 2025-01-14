extends TextureButton

func _ready() -> void :
    SignalBus.start_of_turn_draws.connect(on_start_of_turn_draws)
    SignalBus.expedition_won.connect(on_expedition_won)
    SignalBus.winning_card_played.connect(on_expedition_won)

func on_start_of_turn_draws():
    if GameLogic.is_expedition_won() or GameLogic.is_game_over(): return
    disabled = false

func _on_pressed() -> void :
    if not TurnManager.is_player_input_allowed() or not TurnManager.is_player_turn(): return
    if not DeckManager.initial_hand_drawn: return
    disabled = true
    StatsTracker.turns_taken += 1
    AudioBus.button_clicked.emit()
    SignalBus.turn_ended.emit()

func _on_mouse_entered() -> void :
    if disabled: return
    AudioBus.button_mouse_over.emit()

func on_expedition_won():
    disabled = true
