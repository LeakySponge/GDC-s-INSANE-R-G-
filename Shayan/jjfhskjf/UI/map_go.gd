extends Button

var pop_tween: Tween
const POP_AMOUNT: = 1.2
const POP_TIME: = 0.4

func pop_up():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2(POP_AMOUNT, POP_AMOUNT), POP_TIME)

func pop_down():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
    pop_tween.tween_property(self, "scale", Vector2.ONE, POP_TIME)
    await pop_tween.finished

func _on_mouse_entered() -> void :
    if disabled: return
    pop_up()
    AudioBus.button_mouse_over.emit()

func _on_mouse_exited() -> void :
    if disabled: return
    pop_down()

func _on_pressed() -> void :
    if disabled: return
    disabled = true
    pop_down()
    AudioBus.button_clicked.emit()
    LoadingManager.go_to_scene("res://Game/game.tscn", "starting expedition...", Loader.COLORS.BLUE)
