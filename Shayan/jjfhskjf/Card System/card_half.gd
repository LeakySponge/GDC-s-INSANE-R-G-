extends Control
class_name CardHalf

const EXPLOSION_PARTICLES = preload("res://Particles/explosion_particles.tscn")
const INSPECT_CARD = preload("res://Card System/inspect_card.tscn")

@onready var visual: CardVisualSmall = $CardVisualSmall

var data: CardData

var is_moused_over: = false
var is_discarded: = false

const STATE_MINIMUM_THRESHOLD: = 0.4
var minimum_time_elapsed: = false

@onready var inspect_card: InspectCard = $InspectCard

var offset: = Vector2(-318, -99)

func _ready() -> void :
    var threshold_timer: = get_tree().create_timer(STATE_MINIMUM_THRESHOLD, false)
    threshold_timer.timeout.connect(func(): minimum_time_elapsed = true)

func initialize(data_in: CardData) -> void :
    visible = false
    data = data_in
    visual.data = data
    visual.create_visual()
    inspect_card.initialize(data)
    inspect_card.visible = false
    visible = true

func _physics_process(delta: float) -> void :
    if is_discarded:
        global_position = lerp(global_position, Card.CARD_DISCARD_POSITION + Vector2(0, 70), Card.DISCARD_SPEED)
        return

    if is_moused_over: visual.rotate()
    else: visual.rotate_idle()

    inspect_card.global_position = global_position + offset
    inspect_card.rotation = 0

func _on_button_mouse_entered() -> void :
    if is_discarded: return
    if not minimum_time_elapsed: return
    if CardManager.is_card_dragging() or CardManager.is_card_selected(): return
    z_index = 1
    visual.pop_up()
    is_moused_over = true
    inspect_card.visible = true
    inspect_card.visual.label_white()
    AudioBus.card_moused_over.emit()

func _on_button_mouse_exited() -> void :
    if is_discarded: return
    if not minimum_time_elapsed: return
    if CardManager.is_card_dragging() or CardManager.is_card_selected(): return
    z_index = 0
    visual.pop_down()
    is_moused_over = false
    inspect_card.visible = false

func discard():
    if data.consumable: await visual.flash()

    is_discarded = true
    inspect_card.visible = false

    if data.consumable:
        var p = EXPLOSION_PARTICLES.instantiate()
        p.global_position = global_position + pivot_offset
        p.emitting = true
        Global.particle_folder.add_child(p)
        visual.shrink()

        AudioBus.card_removed.emit()
        SignalBus.deck_changed.emit()

        queue_free()
        return

    visual.flip()
    visual.shrink()

    await get_tree().create_timer(1.0, false).timeout
    queue_free()
