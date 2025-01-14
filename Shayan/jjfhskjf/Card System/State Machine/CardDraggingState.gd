extends CardState

const DRAG_MINIMUM_THRESHOLD: = 0.1
var MIN_TIME_PASSED: = false


func enter():
    card.pivot_offset = card.get_global_mouse_position() - card.global_position

    card.selected.emit()
    card.is_selected = true
    card.z_index += 20

    SignalBus.card_dragged.emit(card)

    await get_tree().create_timer(DRAG_MINIMUM_THRESHOLD, false).timeout
    MIN_TIME_PASSED = true

func exit():
    card.is_selected = false

    SignalBus.card_drag_stopped.emit()

func on_physics_process(delta):
    card.visual.rotate_stop()

    var target_pos: = card.get_global_mouse_position() - card.pivot_offset
    card.global_position = lerp(card.global_position, target_pos, Card.DRAG_MOVEMENT_SPEED)
    card.rotation_degrees = lerp(card.rotation_degrees, 0.0, Card.DRAG_ROTATION_SPEED)

func on_input(event: InputEvent):
    var cancel = event.is_action_pressed("Click") or event.is_action_pressed("Clear") or event.is_action_released("Clear")







    if cancel and MIN_TIME_PASSED:
        transition_requested.emit(self, CardState.State.BASE)
