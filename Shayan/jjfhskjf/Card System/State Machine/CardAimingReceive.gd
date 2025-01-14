extends CardState

func _ready():
    SignalBus.card_aim_ended.connect(on_aim_ended)

func enter():


    card.visual.hide_cost()
    card.visual.glow_yellow()

func exit():
    card.button.mouse_filter = Control.MOUSE_FILTER_STOP

func on_aim_ended(_card: Card):
    transition_requested.emit(self, CardState.State.BASE)

func on_mouse_entered():
    card.z_index += 5
    card.visual.pop_up()
    card.visual.show_selection()
    card.visual.glow_purple()
    AudioBus.card_moused_over.emit()
    SignalBus.receive_aiming_moused_over.emit(card)

    if not CardManager.selected_card.targets.has(card):
        CardManager.selected_card.targets.append(card)

func on_mouse_exited():
    card.z_index = 0
    card.visual.pop_down()
    card.visual.hide_selection()
    card.visual.glow_yellow()

    SignalBus.card_moused_off.emit()

    CardManager.selected_card.targets.erase(card)

func on_physics_process(_delta):
    if card.is_played: return
    if card.is_moused_over: card.visual.rotate()
    else: card.visual.rotate_idle()
