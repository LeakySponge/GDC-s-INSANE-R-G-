extends Node
class_name CardStateMachine

@export var initial_state: CardState

var current_state: CardState
var states: = {}

func init(card: Card):
    for child: CardState in get_children():
        states[child.state] = child
        child.transition_requested.connect(on_transition_requested)
        child.card = card

    if initial_state:
        initial_state.enter()
        current_state = initial_state

func on_input(event: InputEvent):
    if current_state: current_state.on_input(event)

func on_process(delta):
    if current_state: current_state.on_process(delta)

func on_physics_process(delta):
    if current_state: current_state.on_physics_process(delta)

func on_gui_input(event: InputEvent):
    if current_state: current_state.on_gui_input(event)

func on_mouse_entered():
    if current_state: current_state.on_mouse_entered()

func on_mouse_exited():
    if current_state: current_state.on_mouse_exited()

func on_transition_requested(from: CardState, to: CardState.State):
    if from != current_state: return

    var new_state: CardState = states[to]
    if not new_state: return

    if current_state: current_state.exit()

    current_state = new_state
    new_state.enter()