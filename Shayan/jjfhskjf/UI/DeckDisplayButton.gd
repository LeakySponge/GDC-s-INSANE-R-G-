extends Button

var pop_tween: Tween
var tween_pop: Tween
var tween_pop_pop_amount: float = 1.2
var tween_pop_pop_time: float = 0.5

var showing: = false

func _on_pressed():
    pop_tween_down()
    AudioBus.button_clicked.emit()

    if GameLogic.in_shop:
        SignalBus.ask_to_show_deck.emit()
        return

    if not showing:
        SignalBus.ask_to_show_deck.emit()
        showing = true
    else:
        SignalBus.hide_card_pile_display.emit()
        showing = false

func _on_mouse_entered():
    if disabled: return
    AudioBus.button_mouse_over.emit()
    pop_tween_up()

func _on_mouse_exited():
    pop_tween_down()

func pop_tween_up():
    if tween_pop and tween_pop.is_running():
        tween_pop.kill()
    tween_pop = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween_pop.tween_property(self, "scale", Vector2(tween_pop_pop_amount, tween_pop_pop_amount), tween_pop_pop_time)

func pop_tween_down():
    if tween_pop and tween_pop.is_running():
        tween_pop.kill()
    tween_pop = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
    tween_pop.tween_property(self, "scale", Vector2.ONE, tween_pop_pop_time)
