extends CardState

const TEXT_POPUP = preload("res://UI/text_popup.tscn")

const STATE_MINIMUM_THRESHOLD: = 0.5
var minimum_state_time_elapsed: = false

var is_going_to_aim: = false

func _ready():
    SignalBus.energy_changed.connect(check_glow)
    SignalBus.card_aim_started.connect(on_aim_started)
    SignalBus.turn_started.connect(check_if_contains_mouse)
    SignalBus.card_played.connect(on_card_played)


func enter():


    card.visual.show_cost()
    card.visual.pop_down()
    card.visual.opaque()
    card.z_index = 0
    card.visual.hide_selection()
    card.visual.position = Vector2.ZERO
    card.pivot_offset = card.size / 2

    check_if_contains_mouse()

    check_glow()

    is_going_to_aim = false

    minimum_state_time_elapsed = false
    var threshold_timer: = get_tree().create_timer(STATE_MINIMUM_THRESHOLD, false)
    threshold_timer.timeout.connect(func():
        minimum_state_time_elapsed = true
        check_if_contains_mouse()
    )

func on_physics_process(_delta):




    if card.is_played: return
    if card.is_moused_over: card.visual.rotate()
    else: card.visual.rotate_idle()

func on_gui_input(event: InputEvent):
    if CardManager.is_card_dragging(): return
    if GameLogic.is_game_over() or GameLogic.is_expedition_won(): return
    if not minimum_state_time_elapsed: return
    if card.is_played: return

    if event.is_action_pressed("Click"):
        if not TurnManager.is_player_turn() or not TurnManager.is_player_input_allowed(): return
        if card.data.energy_cost > GameLogic.current_energy:
            not_enough_energy()
            return

        card.visual.pop_up()

        if card.data.card_type == CardData.card_types.TARGET:
            is_going_to_aim = true
            transition_requested.emit(self, CardState.State.AIMING)
            return

        if card.data.card_type == CardData.card_types.RESOURCE or card.data.card_type == CardData.card_types.ACTION:
            card.play(true, true)
            return

        SignalBus.card_selected.emit(card)
        card.pivot_offset = card.get_global_mouse_position() - card.global_position
        transition_requested.emit(self, CardState.State.CLICKED)

    if event.is_action_pressed("Clear"):
        if not TurnManager.is_player_turn() or not TurnManager.is_player_input_allowed(): return
        if CardManager.is_card_dragging() or CardManager.is_card_selected(): return

        transition_requested.emit(self, CardState.State.DRAGGING)

func on_mouse_entered():
    if not TurnManager.is_player_turn() or not TurnManager.is_player_input_allowed(): return
    if CardManager.is_card_dragging(): return
    if card.is_played: return


    AudioBus.card_moused_over.emit()

    card.z_index += 1
    card.visual.pop_up()

    if GameLogic.current_energy >= card.data.energy_cost:
        card.visual.glow_blue()

    check_score()

func on_mouse_exited():
    if not TurnManager.is_player_turn() or not TurnManager.is_player_input_allowed(): return
    if CardManager.is_card_dragging(): return
    if card.is_played: return


    card.z_index = 0
    card.visual.pop_down()

    check_glow()

    SignalBus.card_moused_off.emit()

func on_aim_started(_card: Card):
    if is_going_to_aim: return
    transition_requested.emit(self, CardState.State.PRIME_AIMING)

func check_glow():
    if GameLogic.current_energy >= card.data.energy_cost:
        card.visual.glow_white()
    else:
        card.visual.glow_stop()

func check_if_contains_mouse():
    if not card.check_if_contains_mouse(): return

    card.z_index += 1
    card.visual.pop_up()

    if GameLogic.current_energy >= card.data.energy_cost:
        card.visual.glow_blue()

    check_score()

func check_score():
    if card.is_played: return
    if card.data.card_type == CardData.card_types.TARGET: return

    if card.data.ability_1: SignalBus.display_score_on_bar.emit(card.data.ability_1.get_score_value(card))
    if card.data.ability_2: SignalBus.display_score_on_bar.emit(card.data.ability_2.get_score_value(card))

func on_card_played(_card: Card):
    check_if_contains_mouse()

func not_enough_energy():
    AudioBus.not_enough_energy.emit()
    var new_popup: TextPopup = TEXT_POPUP.instantiate()
    new_popup.create("not enough energy!", card.get_global_mouse_position(), Global.particle_folder_cv)
    card.visual.flash_red()
    await card.visual.pop_up()
    await card.visual.pop_down()
    if card.check_if_contains_mouse(): card.visual.pop_up()
