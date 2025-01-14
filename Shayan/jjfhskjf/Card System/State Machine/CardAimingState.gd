extends CardState

const STATE_MINIMUM_THRESHOLD: = 0.2
var minimum_state_time_elapsed: = false

func enter():

    SignalBus.card_selected.emit(card)
    SignalBus.card_aim_started.emit(card)
    card.visual.glow_purple()
    card.visual.z_index = 2
    card.visual.opaque()

    minimum_state_time_elapsed = false
    var threshold_timer: = get_tree().create_timer(STATE_MINIMUM_THRESHOLD, false)
    threshold_timer.timeout.connect(func(): minimum_state_time_elapsed = true)

func exit():
    SignalBus.card_aim_ended.emit(card)
    card.visual.z_index = 0

func on_input(event: InputEvent) -> void :
    var mouse_motion: = event is InputEventMouseMotion
    var confirm = event.is_action_pressed("Click") or event.is_action_released("Click")

    if event.is_action_pressed("Clear"): card.deselect()
    elif event.is_action_pressed("Click") or event.is_action_released("Click"):
        if card.targets.size() == 0 or (card.targets[0].get_parent() == card):
            if not minimum_state_time_elapsed: return
            card.deselect()
            return



        get_viewport().set_input_as_handled()
        card.play(true, true)

func on_physics_process(_delta):
    if card.is_played: return
    card.visual.rotate_stop()
