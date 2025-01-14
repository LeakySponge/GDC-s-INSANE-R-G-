extends CardState

func _ready():
    SignalBus.card_aim_ended.connect(on_aim_ended)

func enter():


    card.z_index = -1
    card.visual.hide_cost()
    card.visual.see_through()
    card.visual.glow_stop()

    card.button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func exit():
    card.button.mouse_filter = Control.MOUSE_FILTER_STOP

func on_aim_ended(_card: Card):
    transition_requested.emit(self, CardState.State.BASE)

func on_mouse_entered():
    return

func on_mouse_exited():
    return

func on_physics_process(_delta):
    card.visual.rotate_idle()
