extends Control
class_name CardVisualSmall

const CARD_BASE_ART_HALF = preload("res://Art/CardBaseArtHalf.png")
const CARD_BASE_ART_HALF_RED = preload("res://Art/CardBaseArtHalfRed.png")
const CARD_BASE_ART_HALF_YELLOW = preload("res://Art/CardBaseArtHalfYellow.png")
const CARD_BASE_ART_HALF_PURPLE = preload("res://Art/CardBaseArtHalfPurple.png")

@onready var art_viewport: SubViewportContainer = $"Art Viewport"
@onready var resource_viewport: SubViewportContainer = $"Resource Viewport"

@onready var art: Control = $"Art Viewport/SubViewport/Art"
@onready var front: Control = $"Art Viewport/SubViewport/Art/Front"
@onready var back: Control = $"Art Viewport/SubViewport/Art/Back"

@onready var base_art: TextureRect = $"Art Viewport/SubViewport/Art/Front/Base Art"
@onready var half_card_artwork: TextureRect = $"Art Viewport/SubViewport/Art/Front/HalfCardArtwork"
@onready var full_card_artwork: TextureRect = $"Art Viewport/SubViewport/Art/Front/FullCardArtwork"

@onready var resource_value: TextureRect = $"Resource Viewport/SubViewport/Art/Front/ResourceValue"
@onready var resource_label: Label = $"Resource Viewport/SubViewport/Art/Front/ResourceValue/SubViewportContainer/SubViewport/ResourceLabel"

@onready var score_value: TextureRect = $"Resource Viewport/SubViewport/Art/Front/ScoreValue"
@onready var score_label: Label = $"Resource Viewport/SubViewport/Art/Front/ScoreValue/SubViewportContainer/SubViewport/ScoreLabel"

@onready var flash_art: TextureRect = $Flash





var flip_tween: Tween
var flip_tween_2: Tween
const FLIP_TIME: = 0.2


var pop_tween: Tween
const POP_AMOUNT: = 1.2
const POP_TIME: = 0.4
const POP_DOWN_TIME: = 0.6
const POP_SELECTED_AMOUNT: = 1.4
const POP_SELECTED_TIME: = 0.7
const POP_FLAT_TIME: = 1.0


var rotation_tween: Tween
var ROTATION_TIME: = 0.5
var ROTATION_SPEED: = 0.75
var ROTATION_ANGLE_X_MAX: = 5
var ROTATION_ANGLE_y_MAX: = 5


var IDLE_ROTATION_SEED: = randf_range(0, 999999)
const IDLE_ROTATION_SPEED_DIVIDER: = 10
var IDLE_ROTATION_SPEED_FLUFF = randf_range(0.0, 2.0)
var IDLE_ROTATION_ANGLE_MAX: = 3.5


var flash_tween: Tween
var FLASH_TIME: float = 0.25
var pop_tween_played_pop_amount: float = 1.4
var pop_tween_played_pop_time: float = 0.15

var data: CardData

func _ready() -> void :
    front.visible = true
    back.visible = false

func initialize(data_in: CardData):
    data = data_in
    create_visual()

func create_visual():
    if not data: return

    match data.card_type:
        CardData.card_types.RESOURCE:
            full_card_artwork.visible = true
            half_card_artwork.visible = false
            full_card_artwork.texture = data.art
            score_label.text = str(data.resource_value)
            resource_label.text = str(data.resource_value)

            if data.resource_type == CardData.resource_types.ORE:
                resource_value.visible = true
                score_value.visible = false
                base_art.texture = CARD_BASE_ART_HALF_RED
                if data.resource_value < CardVisual.RESOURCE_THRESHOLD_2: full_card_artwork.texture = CardVisual.ART_ORE_1
                elif data.resource_value >= CardVisual.RESOURCE_THRESHOLD_2 and data.resource_value < CardVisual.RESOURCE_THRESHOLD_3: full_card_artwork.texture = CardVisual.ART_ORE_2
                elif data.resource_value >= CardVisual.RESOURCE_THRESHOLD_3 and data.resource_value < CardVisual.RESOURCE_THRESHOLD_4: full_card_artwork.texture = CardVisual.ART_ORE_3
                elif data.resource_value >= CardVisual.RESOURCE_THRESHOLD_4 and data.resource_value < CardVisual.RESOURCE_THRESHOLD_5: full_card_artwork.texture = CardVisual.ART_ORE_4
                elif data.resource_value >= CardVisual.RESOURCE_THRESHOLD_5 and data.resource_value < CardVisual.RESOURCE_THRESHOLD_6: full_card_artwork.texture = CardVisual.ART_ORE_5
                elif data.resource_value >= CardVisual.RESOURCE_THRESHOLD_6: full_card_artwork.texture = CardVisual.ART_ORE_6
            elif data.resource_type == CardData.resource_types.SCORIUM:
                resource_value.visible = false
                score_value.visible = true
                base_art.texture = CARD_BASE_ART_HALF_YELLOW
                if data.resource_value < CardVisual.RESOURCE_THRESHOLD_2: full_card_artwork.texture = CardVisual.ART_SCORIUM_1
                elif data.resource_value >= CardVisual.RESOURCE_THRESHOLD_2 and data.resource_value < CardVisual.RESOURCE_THRESHOLD_3: full_card_artwork.texture = CardVisual.ART_SCORIUM_2
                elif data.resource_value >= CardVisual.RESOURCE_THRESHOLD_3 and data.resource_value < CardVisual.RESOURCE_THRESHOLD_4: full_card_artwork.texture = CardVisual.ART_SCORIUM_3
                elif data.resource_value >= CardVisual.RESOURCE_THRESHOLD_4 and data.resource_value < CardVisual.RESOURCE_THRESHOLD_5: full_card_artwork.texture = CardVisual.ART_SCORIUM_4
                elif data.resource_value >= CardVisual.RESOURCE_THRESHOLD_5 and data.resource_value < CardVisual.RESOURCE_THRESHOLD_6: full_card_artwork.texture = CardVisual.ART_SCORIUM_5
                elif data.resource_value >= CardVisual.RESOURCE_THRESHOLD_6: full_card_artwork.texture = CardVisual.ART_SCORIUM_6

        CardData.card_types.ACTION:
            full_card_artwork.visible = false
            half_card_artwork.visible = true
            resource_value.visible = false
            score_value.visible = false
            half_card_artwork.texture = data.art
            base_art.texture = CARD_BASE_ART_HALF

        CardData.card_types.TARGET:
            full_card_artwork.visible = false
            half_card_artwork.visible = true
            resource_value.visible = false
            score_value.visible = false
            half_card_artwork.texture = data.art
            base_art.texture = CARD_BASE_ART_HALF_PURPLE




func set_rotation_x(value, speed):
    art_viewport.material.set_shader_parameter("x_rot", lerp(art_viewport.material.get_shader_parameter("x_rot"), value, speed))
    resource_viewport.material.set_shader_parameter("x_rot", lerp(resource_viewport.material.get_shader_parameter("x_rot"), value, speed))

func set_rotation_y(value, speed):
    art_viewport.material.set_shader_parameter("y_rot", lerp(art_viewport.material.get_shader_parameter("y_rot"), value, speed))
    resource_viewport.material.set_shader_parameter("y_rot", lerp(resource_viewport.material.get_shader_parameter("y_rot"), value, speed))

func rotate():
    var mouse_pos: Vector2 = get_local_mouse_position()

    var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
    var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)

    var rot_x: float = lerp( - ROTATION_ANGLE_X_MAX, ROTATION_ANGLE_X_MAX, lerp_val_x)
    var rot_y: float = lerp(ROTATION_ANGLE_y_MAX, - ROTATION_ANGLE_y_MAX, lerp_val_y)

    rot_x = clamp(rot_x, - ROTATION_ANGLE_X_MAX, ROTATION_ANGLE_X_MAX)
    rot_y = clamp(rot_y, - ROTATION_ANGLE_y_MAX, ROTATION_ANGLE_y_MAX)

    set_rotation_x(rot_y, ROTATION_SPEED)
    set_rotation_y(rot_x, ROTATION_SPEED)

func rotate_stop():
    set_rotation_x(0.0, ROTATION_SPEED / 2)
    set_rotation_y(0.0, ROTATION_SPEED / 2)

func rotate_idle():
    var rot_speed_divider = IDLE_ROTATION_SPEED_DIVIDER + IDLE_ROTATION_SPEED_FLUFF
    var x: = cos(deg_to_rad(Time.get_ticks_msec() / rot_speed_divider) + IDLE_ROTATION_SEED) * IDLE_ROTATION_ANGLE_MAX
    var y: = sin(deg_to_rad(Time.get_ticks_msec() / rot_speed_divider) + IDLE_ROTATION_SEED) * IDLE_ROTATION_ANGLE_MAX
    set_rotation_x(x, ROTATION_SPEED / 2)
    set_rotation_y(y, ROTATION_SPEED / 2)



func shrink():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2.ZERO, POP_FLAT_TIME)

func flip():
    art.scale.x = 1

    if flip_tween and flip_tween.is_running(): flip_tween.kill()
    flip_tween = create_tween().set_ease(Tween.EASE_OUT)
    flip_tween.tween_property(art, "scale:x", 0, FLIP_TIME / 2)
    await flip_tween.finished

    front.visible = false
    back.visible = true
    resource_viewport.visible = false

    flip_tween_2 = create_tween().set_ease(Tween.EASE_OUT)
    flip_tween_2.tween_property(art, "scale:x", 1, FLIP_TIME / 2)

func pop_up():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2(POP_AMOUNT, POP_AMOUNT), POP_TIME)

func pop_up_large():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2(POP_SELECTED_AMOUNT, POP_SELECTED_AMOUNT), POP_SELECTED_TIME)

func pop_down():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
    pop_tween.tween_property(self, "scale", Vector2.ONE, POP_DOWN_TIME)
    await pop_tween.finished

func flash():
    if pop_tween and pop_tween.is_running():
        pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2(pop_tween_played_pop_amount, pop_tween_played_pop_amount), pop_tween_played_pop_time)

    flash_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
    flash_tween.tween_property(flash_art, "modulate:a", 255, FLASH_TIME)
    await flash_tween.finished
