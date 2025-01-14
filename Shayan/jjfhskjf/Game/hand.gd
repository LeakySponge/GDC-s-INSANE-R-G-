extends Control
class_name Hand

const CARD_SLOT = preload("res://Card System/card_slot.tscn")

@onready var slots: Control = $Slots

var time: = 0.0

const BASE_SEPARATION: = 50
const SHRINK_AFTER_CARD_COUNT: = 5
const MAX_ROTATION_DEGREES: = 5


@export var hand_curve: Curve
@export var hand_curve_2: Curve
@export var rotation_curve: Curve

var x_adjust: = -40
var x_sep: = 20
var y_min: = 0
var y_max: = -35
var y_flat: = -40

var card_bob_tween: Tween
var card_bob_tween_timer: Timer
var sine_offset_mult: = 0.0
var anim_offset_y: float = 0.05
var card_bob_time: = 5.0

func _ready() -> void :


    SignalBus.card_deselected.connect(on_card_deselected)
    SignalBus.card_played.connect(on_card_played)

    card_bob_tween_timer = Timer.new()
    add_child(card_bob_tween_timer)
    card_bob_tween_timer.wait_time = card_bob_time
    card_bob_tween_timer.start()
    card_bob_tween_timer.timeout.connect(start_card_bob)

func _physics_process(delta: float) -> void :
    if CardManager.is_card_dragging(): check_for_swaps()

    time += delta
    for i in slots.get_children().size():
        var slot: CardSlot = slots.get_child(i)
        var val: float = sin(i + (time * 1.0))
        if slot.held_card.is_moused_over: continue
        slot.position.y += val * sine_offset_mult

func on_card_deselected(_card: Card):
    pass

func on_card_drawn():
    update_cards()

func on_card_discarded():
    update_cards()

func start_card_bob():
    card_bob_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
    card_bob_tween.tween_property(self, "sine_offset_mult", anim_offset_y, card_bob_time)

func draw(data: CardData):
    var new_slot: CardSlot = CARD_SLOT.instantiate()
    slots.add_child(new_slot)
    new_slot.spawn_card(data)
    new_slot.held_card.draw()
    update_cards()

func discard() -> CardData:
    if slots.get_children().size() <= 0: return
    var data_to_return: CardData = slots.get_children().back().clear()
    update_cards()
    return data_to_return

func update_cards():
    var num_cards: = slots.get_child_count()
    var total_card_size: = 150 * num_cards + x_sep * (num_cards - 1)
    var final_x_sep: = x_sep

    if total_card_size > size.x:
        final_x_sep = (size.x - 150 * num_cards) / (num_cards - 1)
        total_card_size = size.x

    var offset: = (size.x - total_card_size) / 2

    for i in num_cards:
        var slot: = slots.get_child(i)
        var y_multiplier: = hand_curve.sample(1.0 / (num_cards - 1) * i)
        if num_cards <= 5: y_multiplier = hand_curve_2.sample(1.0 / (num_cards - 1) * i)
        var rot_multiplier: = rotation_curve.sample(1.0 / (num_cards - 1) * i)

        if num_cards == 1:
            y_multiplier = 0.0
            rot_multiplier = 0.0

        var final_x: float = offset + (150 * i) + (final_x_sep * i)
        var final_y: float = y_min + y_max * y_multiplier + y_flat
        final_y += sin(i + (time * 1.0)) * sine_offset_mult

        slot.position = Vector2(final_x + x_adjust, final_y)
        slot.rotation_degrees = MAX_ROTATION_DEGREES * rot_multiplier

        if num_cards <= 5: slot.rotation_degrees = slot.rotation_degrees * 0.5

func check_for_swaps():
    if not CardManager.dragging_card.slot: return

    for slot: CardSlot in slots.get_children():
        if slot.held_card == CardManager.dragging_card: continue
        if CardManager.dragging_card.global_position.x > slot.held_card.global_position.x and slot.get_index() > CardManager.dragging_card.slot.get_index():
            swap_slots(CardManager.dragging_card.slot, slot)
            return
        if CardManager.dragging_card.global_position.x < slot.held_card.global_position.x and slot.get_index() < CardManager.dragging_card.slot.get_index():
            swap_slots(CardManager.dragging_card.slot, slot)
            return

func swap_slots(slot_1: CardSlot, slot_2: CardSlot):
    var original_slot_position = slot_1.global_position
    var original_slot_rotation = slot_1.rotation_degrees

    slot_1.global_position = slot_2.global_position
    slot_1.rotation_degrees = slot_2.rotation_degrees
    slot_2.global_position = original_slot_position
    slot_2.rotation_degrees = original_slot_rotation

    slots.move_child(slot_1, slot_2.get_index())
    Global.card_holder.move_child(slot_1.held_card, slot_2.held_card.get_index())
    update_cards()

func on_card_played(_card: Card):
    update_cards()
