extends Node
class_name CardState

enum State{BASE, CLICKED, DRAGGING, AIMING, RELEASED, RECEIVE_AIMING, DISCARD, PRIME_AIMING, FADE_AIMING}

signal transition_requested(from: CardState, to: CardState)

@export var state: State

var card: Card

func enter() -> void :
    pass

func exit() -> void :
    pass

func on_input(_event: InputEvent) -> void :
    pass

func on_process(_delta):
    pass

func on_physics_process(_delta):
    pass

func on_gui_input(_event: InputEvent) -> void :
    pass

func on_mouse_entered() -> void :
    pass

func on_mouse_exited() -> void :
    pass
