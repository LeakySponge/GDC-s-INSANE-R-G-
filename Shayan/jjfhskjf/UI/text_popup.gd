extends Label
class_name TextPopup

var pop_tween: Tween
var fade_tween: Tween
var slide_tween: Tween

func create(text_in: String, pos: Vector2, folder):
    folder.add_child(self)

    text = text_in
    pivot_offset = size / 2

    global_position = pos + Vector2(-160, 0)

    pop()
    fade()
    slide()

    await get_tree().create_timer(1.5, false).timeout
    queue_free()




func pop():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2)
    pop_tween.tween_property(self, "scale", Vector2.ONE, 0.3)

func fade():
    if fade_tween and fade_tween.is_running(): fade_tween.kill()
    modulate.a = 0.0
    fade_tween = create_tween().set_ease(Tween.EASE_OUT)
    fade_tween.tween_property(self, "modulate:a", 1.0, 0.3)
    fade_tween.tween_property(self, "modulate:a", 0.0, 1.2)

func slide():
    if slide_tween and slide_tween.is_running(): slide_tween.kill()
    fade_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    fade_tween.tween_property(self, "global_position", global_position + Vector2(0, -60), 1.5)
