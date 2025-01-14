extends CardState

func enter():
    card.is_discarded = true
    card.is_selected = false
    card.is_moused_over = false

    card.visual.z_index = -3
    card.visual.flip()
    card.visual.shrink()

    card.button.mouse_filter = Control.MOUSE_FILTER_IGNORE

    await get_tree().create_timer(1.0, false).timeout
    card.queue_free()

func on_physics_process(delta):
    card.global_position = lerp(card.global_position, Card.CARD_DISCARD_POSITION, Card.DISCARD_SPEED)
