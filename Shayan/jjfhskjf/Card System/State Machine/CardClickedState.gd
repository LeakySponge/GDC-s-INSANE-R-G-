extends CardState

func enter():



    card.z_index += 1

func on_input(event: InputEvent):
    if event is InputEventMouseMotion:
        transition_requested.emit(self, CardState.State.AIMING)
