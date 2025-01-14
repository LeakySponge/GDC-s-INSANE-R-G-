extends Control
class_name CardSlot

const CARD = preload("res://Card System/Card.tscn")
const CARD_HALF = preload("res://Card System/card_half.tscn")

var held_card: Card
var held_half: CardHalf

const CARD_MOVEMENT_SPEED: = 0.1
const CARD_ROTATION_SPEED: = 0.1

func _ready() -> void :
    pass

func _physics_process(_delta: float) -> void :
    if held_half:
        held_half.global_position = lerp(held_half.global_position, global_position, CARD_MOVEMENT_SPEED)
        held_half.rotation = lerp(held_half.rotation, rotation, CARD_ROTATION_SPEED)
        return

    if not held_card: return
    if held_card.is_selected: return

    held_card.global_position = lerp(held_card.global_position, global_position, CARD_MOVEMENT_SPEED)
    held_card.rotation = lerp(held_card.rotation, rotation, CARD_ROTATION_SPEED)

func spawn_card(data: CardData):
    var new_card = CARD.instantiate()
    Global.card_holder.add_child(new_card)
    held_card = new_card
    new_card.slot = self
    new_card.initialize(data)

    new_card.selected.connect(on_held_selected)
    new_card.deselected.connect(on_held_deselected)

func spawn_card_half(card: Card):
    var new_card = CARD_HALF.instantiate()

    Global.card_half_holder.add_child(new_card)

    held_half = new_card
    new_card.global_position = card.global_position
    new_card.rotation = card.rotation
    new_card.initialize(card.data)

func on_held_selected():
    pass

func on_held_deselected():
    pass

func clear():
    queue_free()
    if held_half:
        held_half.discard()
        return held_half.data
    if held_card:
        held_card.discard()
        return held_card.data
