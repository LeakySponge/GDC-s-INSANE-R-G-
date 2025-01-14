extends Control
class_name CardVisual




const CARD_BASE_ART = preload("res://Art/CardBaseArt.png")
const CARD_BASE_ART_RED = preload("res://Art/CardBaseArtRed.png")
const CARD_BASE_ART_YELLOW = preload("res://Art/CardBaseArtYellow.png")
const CARD_BASE_ART_PURPLE = preload("res://Art/CardBaseArtPurple.png")
const CARD_BASE_ART_GREEN = preload("res://Art/CardBaseArtGreen.png")
const CARD_EMPTY_ART = preload("res://Art/CardEmptyArt.png")

const BLUE_GLOW = preload("res://Card System/Glow/BlueGlow.tres")
const PURPLE_GLOW = preload("res://Card System/Glow/PurpleGlow.tres")
const WHITE_GLOW = preload("res://Card System/Glow/WhiteGlow.tres")
const YELLOW_GLOW = preload("res://Card System/Glow/YellowGlow.tres")

const CARD_COST_SYMBOL_SQUARE = preload("res://Art/CardCostSymbolSquare.png")
const CARD_COST_SYMBOL_SQUARE_BLUE = preload("res://Art/CardCostSymbolSquareBlue.png")

const ART_ORE_1 = preload("res://Art/Card Artworks/Ore 1.png")
const ART_ORE_2 = preload("res://Art/Card Artworks/Ore 2.png")
const ART_ORE_3 = preload("res://Art/Card Artworks/Ore 3.png")
const ART_ORE_4 = preload("res://Art/Card Artworks/Ore 4.png")
const ART_ORE_5 = preload("res://Art/Card Artworks/Ore 5.png")
const ART_ORE_6 = preload("res://Art/Card Artworks/Ore 6.png")

const ART_SCORIUM_1 = preload("res://Art/Card Artworks/Scorium 1.png")
const ART_SCORIUM_2 = preload("res://Art/Card Artworks/Scorium 2.png")
const ART_SCORIUM_3 = preload("res://Art/Card Artworks/Scorium 3.png")
const ART_SCORIUM_4 = preload("res://Art/Card Artworks/Scorium 4.png")
const ART_SCORIUM_5 = preload("res://Art/Card Artworks/Scorium 5.png")
const ART_SCORIUM_6 = preload("res://Art/Card Artworks/Scorium 6.png")



@onready var art: Control = $"Art Viewport/SubViewport/Art"
@onready var back: Control = $"Art Viewport/SubViewport/Art/Back"
@onready var front: Control = $"Art Viewport/SubViewport/Art/Front"

@onready var cost_viewport: SubViewportContainer = $"Cost Viewport"
@onready var art_viewport: SubViewportContainer = $"Art Viewport"

@onready var base_art: TextureRect = $"Art Viewport/SubViewport/Art/Front/Base Art"
@onready var half_card_artwork: TextureRect = $"Art Viewport/SubViewport/Art/Front/HalfCardArtwork"
@onready var full_card_artwork: TextureRect = $"Art Viewport/SubViewport/Art/Front/FullCardArtwork"
@onready var divider: TextureRect = $"Art Viewport/SubViewport/Art/Front/Divider"
@onready var resource_value: TextureRect = $"Art Viewport/SubViewport/Art/Front/ResourceValue"
@onready var score_value: TextureRect = $"Art Viewport/SubViewport/Art/Front/ScoreValue"
@onready var name_container: SubViewportContainer = $"Art Viewport/SubViewport/Art/Front/Labels/Name Container"
@onready var small_name_container: SubViewportContainer = $"Art Viewport/SubViewport/Art/Front/Labels/Small Name Container"
@onready var cost_indicator: TextureRect = $"Cost Viewport/SubViewport/Cost Indicator"

@onready var name_label: Label = $"Art Viewport/SubViewport/Art/Front/Labels/Name Container/SubViewport/Name Label"
@onready var small_name_label: Label = $"Art Viewport/SubViewport/Art/Front/Labels/Small Name Container/SubViewport/Name Label"
@onready var description_label: RichTextLabel = $"Art Viewport/SubViewport/Art/Front/Labels/DescriptionLabel"
@onready var resource_label: Label = $"Art Viewport/SubViewport/Art/Front/ResourceValue/SubViewportContainer/SubViewport/ResourceLabel"
@onready var score_label: Label = $"Art Viewport/SubViewport/Art/Front/ScoreValue/SubViewportContainer/SubViewport/ScoreLabel"
@onready var cost_label: Label = $"Cost Viewport/SubViewport/Cost Indicator/CostLabel"
@onready var type_label: Label = $"Art Viewport/SubViewport/Art/Front/Labels/TypeContainer/SubViewport/TypeLabel"

@onready var shadow: TextureRect = $Shadow
@onready var glow: Panel = $"Art Viewport/SubViewport/Art/Glow"
@onready var selection_indicator: Control = $"Selection Indicator"
@onready var flash_art: TextureRect = $Flash
@onready var flash_red_art: TextureRect = $"Flash Red"
@onready var stamp: TextureRect = $"Art Viewport/SubViewport/Art/Stamp"




const RESOURCE_THRESHOLD_1: = 1
const RESOURCE_THRESHOLD_2: = 2
const RESOURCE_THRESHOLD_3: = 4
const RESOURCE_THRESHOLD_4: = 7
const RESOURCE_THRESHOLD_5: = 12
const RESOURCE_THRESHOLD_6: = 20





var pop_tween: Tween
const POP_AMOUNT: = 1.2
const POP_TIME: = 0.4
const POP_DOWN_TIME: = 0.6
const POP_SELECTED_AMOUNT: = 1.4
const POP_SELECTED_TIME: = 0.7
const POP_FLAT_TIME: = 1.0


var flip_tween: Tween
var flip_tween_2: Tween
const FLIP_TIME: = 0.2

var cost_tween: Tween
const COST_POP_TIME = 0.5


var rotation_tween: Tween
var ROTATION_TIME: = 0.5
var ROTATION_SPEED: = 0.75
var ROTATION_ANGLE_X_MAX: = 5
var ROTATION_ANGLE_y_MAX: = 5


var flash_tween: Tween
var FLASH_TIME: float = 0.25
var pop_tween_played_pop_amount: float = 1.4
var pop_tween_played_pop_time: float = 0.15


var IDLE_ROTATION_SEED: = randf_range(0, 999999)
const IDLE_ROTATION_SPEED_DIVIDER: = 10
var IDLE_ROTATION_SPEED_FLUFF = randf_range(0.0, 2.0)
var IDLE_ROTATION_ANGLE_MAX: = 3.5




var card
var data: CardData



func _ready() -> void :
    hide_stamp()
    glow_stop()



    SignalBus.energy_changed.connect(update_labels)




func show_cost():
    cost_viewport.visible = true
    cost_viewport.scale = Vector2.ZERO
    if cost_tween and cost_tween.is_running(): cost_tween.kill()
    cost_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
    cost_tween.tween_property(cost_viewport, "scale", Vector2.ONE, COST_POP_TIME)

func hide_cost():
    cost_viewport.visible = false

func show_selection():
    selection_indicator.get_node("AnimationPlayer").play("Idle")
    selection_indicator.visible = true

func hide_selection():
    selection_indicator.visible = false

func create_visual():
    if not data: return
    update_visuals()

func update_visuals():
    update_stamp()
    update_art()
    update_labels()

func empty():
    base_art.texture = CARD_EMPTY_ART

    cost_viewport.visible = false
    name_label.visible = false
    type_label.visible = false
    full_card_artwork.visible = false
    half_card_artwork.visible = false
    divider.visible = false
    resource_value.visible = false
    score_value.visible = false
    description_label.visible = false
    small_name_container.visible = false




func face_down():
    front.visible = false
    back.visible = true
    cost_viewport.visible = false

func face_up():
    front.visible = true
    back.visible = false
    cost_viewport.visible = true

func flip():
    art.scale.x = 1

    if flip_tween and flip_tween.is_running(): flip_tween.kill()
    flip_tween = create_tween().set_ease(Tween.EASE_OUT)
    flip_tween.tween_property(art, "scale:x", 0, FLIP_TIME / 2)
    await flip_tween.finished

    front.visible = not front.visible
    back.visible = not back.visible
    cost_viewport.visible = not cost_viewport.visible
    if front.visible: cost_viewport.scale = Vector2.ZERO

    flip_tween_2 = create_tween().set_ease(Tween.EASE_OUT)
    flip_tween_2.tween_property(art, "scale:x", 1, FLIP_TIME / 2)
    flip_tween_2.set_trans(Tween.TRANS_ELASTIC)

    if front.visible: show_cost()

func pop_up():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2(POP_AMOUNT, POP_AMOUNT), POP_TIME)
    await pop_tween

func pop_up_large():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2(POP_SELECTED_AMOUNT, POP_SELECTED_AMOUNT), POP_SELECTED_TIME)
    await pop_tween

func pop_down():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
    pop_tween.tween_property(self, "scale", Vector2.ONE, POP_DOWN_TIME)
    await pop_tween.finished

func pop_flat():
    scale = Vector2.ZERO
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2.ONE, POP_FLAT_TIME)

func shrink():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2.ZERO, POP_FLAT_TIME)

func flash():
    if pop_tween and pop_tween.is_running():
        pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2(pop_tween_played_pop_amount, pop_tween_played_pop_amount), pop_tween_played_pop_time)

    flash_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
    flash_tween.tween_property(flash_art, "modulate:a", 255, FLASH_TIME)
    await flash_tween.finished

func flash_pop():
    if pop_tween and pop_tween.is_running():
        pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2(pop_tween_played_pop_amount, pop_tween_played_pop_amount), pop_tween_played_pop_time)

    flash_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
    flash_tween.tween_property(flash_art, "modulate:a", 255, FLASH_TIME)
    flash_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    flash_tween.tween_property(flash_art, "modulate:a", 0, FLASH_TIME)
    await flash_tween.finished

func flash_down():
    if flash_tween and flash_tween.is_running(): flash_tween.kill()

    flash_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
    flash_tween.tween_property(flash_art, "modulate:a", 255, FLASH_TIME * 1.5)
    flash_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    flash_tween.tween_property(flash_art, "modulate:a", 0, FLASH_TIME * 1.5)

    await flash_tween.finished

func flash_up_then_down():
    if flash_tween and flash_tween.is_running(): flash_tween.kill()

    flash_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
    flash_tween.tween_property(flash_art, "modulate:a", 255, FLASH_TIME)
    flash_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    flash_tween.tween_property(flash_art, "modulate:a", 0, FLASH_TIME)

    await flash_tween.finished

func flash_red():
    if flash_tween and flash_tween.is_running(): flash_tween.kill()

    flash_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
    flash_tween.tween_property(flash_red_art, "modulate:a", 1.0, FLASH_TIME / 10)
    flash_tween.tween_property(flash_red_art, "modulate:a", 0.0, FLASH_TIME * 1.5)
    await flash_tween.finished

func pop_up_then_down():
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2(POP_AMOUNT, POP_AMOUNT), POP_TIME)
    pop_tween.set_trans(Tween.TRANS_ELASTIC)
    pop_tween.tween_property(self, "scale", Vector2.ONE, POP_TIME)
    await pop_tween

func pop_up_then_down_from_zero():
    scale = Vector2.ZERO
    if pop_tween and pop_tween.is_running(): pop_tween.kill()
    pop_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    pop_tween.tween_property(self, "scale", Vector2(POP_AMOUNT, POP_AMOUNT), POP_TIME)
    pop_tween.set_trans(Tween.TRANS_ELASTIC)
    pop_tween.tween_property(self, "scale", Vector2.ONE, POP_TIME / 2)
    await pop_tween

func pop_both():
    await pop_up()
    await pop_down()




func set_rotation_x(value, speed):
    art_viewport.material.set_shader_parameter("x_rot", lerp(art_viewport.material.get_shader_parameter("x_rot"), value, speed))
    cost_viewport.material.set_shader_parameter("x_rot", lerp(cost_viewport.material.get_shader_parameter("x_rot"), value, speed))

func set_rotation_y(value, speed):
    art_viewport.material.set_shader_parameter("y_rot", lerp(art_viewport.material.get_shader_parameter("y_rot"), value, speed))
    cost_viewport.material.set_shader_parameter("y_rot", lerp(cost_viewport.material.get_shader_parameter("y_rot"), value, speed))

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




func glow_white():
    if not glow: return
    glow.visible = true
    glow.set("theme_override_styles/panel", WHITE_GLOW)

func glow_blue():
    if not glow: return
    glow.visible = true
    glow.set("theme_override_styles/panel", BLUE_GLOW)

func glow_yellow():
    if not glow: return
    glow.visible = true
    glow.set("theme_override_styles/panel", YELLOW_GLOW)

func glow_purple():
    if not glow: return
    glow.visible = true
    glow.set("theme_override_styles/panel", PURPLE_GLOW)

func glow_stop():
    if not glow: return
    glow.visible = false




func opaque():
    art.modulate.a = 1.0

func see_through():
    art.modulate.a = 0.5

func slightly_see_through():
    art.modulate.a = 0.8




func update_labels():
    if not data: return

    update_description()

    resource_label.text = str(data.resource_value)
    score_label.text = str(data.resource_value)
    cost_label.text = str(data.energy_cost)
    name_container.visible = true

    if data.energy_cost == 0:
        cost_indicator.texture = CARD_COST_SYMBOL_SQUARE_BLUE
    else:
        cost_indicator.texture = CARD_COST_SYMBOL_SQUARE

    var name_to_set: = data.name

    if data.resource_type == CardData.resource_types.ORE:
        if data.resource_value < RESOURCE_THRESHOLD_2: name_to_set = "small ore"
        elif data.resource_value >= RESOURCE_THRESHOLD_2 and data.resource_value < RESOURCE_THRESHOLD_3: name_to_set = "ore"
        elif data.resource_value >= RESOURCE_THRESHOLD_3 and data.resource_value < RESOURCE_THRESHOLD_4: name_to_set = "ore"
        elif data.resource_value >= RESOURCE_THRESHOLD_4 and data.resource_value < RESOURCE_THRESHOLD_5: name_to_set = "big ore"
        elif data.resource_value >= RESOURCE_THRESHOLD_5 and data.resource_value < RESOURCE_THRESHOLD_6: name_to_set = "huge ore"
        elif data.resource_value >= RESOURCE_THRESHOLD_6: name_to_set = "giant ore"

    if data.resource_type == CardData.resource_types.SCORIUM:
        if data.resource_value < RESOURCE_THRESHOLD_2: name_to_set = "small scorium"
        elif data.resource_value >= RESOURCE_THRESHOLD_2 and data.resource_value < RESOURCE_THRESHOLD_3: name_to_set = "scorium"
        elif data.resource_value >= RESOURCE_THRESHOLD_3 and data.resource_value < RESOURCE_THRESHOLD_4: name_to_set = "scorium"
        elif data.resource_value >= RESOURCE_THRESHOLD_4 and data.resource_value < RESOURCE_THRESHOLD_5: name_to_set = "big scorium"
        elif data.resource_value >= RESOURCE_THRESHOLD_5 and data.resource_value < RESOURCE_THRESHOLD_6: name_to_set = "huge scorium"
        elif data.resource_value >= RESOURCE_THRESHOLD_6: name_to_set = "giant scorium"

    name_label.text = name_to_set.to_lower()
    small_name_label.text = name_to_set.to_lower()

    if name_to_set.length() >= 8:
        name_container.visible = false
        small_name_container.visible = true
    else:
        name_container.visible = true
        small_name_container.visible = false

    if card is InspectCard: return
    if card is ShopCard: return

    if data.energy_cost > GameLogic.current_energy:
        cost_label.set("theme_override_colors/font_color", "d43a2b")
    else:
        cost_label.set("theme_override_colors/font_color", "f7fff8")

func update_description():
    description_label.text = data.description

    if data.plus_cards == 1: description_label.text.replace("Cards", "Card")

    description_label.text = TextUtilities.center(description_label.text)
    description_label.text = TextUtilities.add_colors(description_label.text)
    description_label.text = TextUtilities.add_icons(description_label.text)
    description_label.text = TextUtilities.font_sizes(description_label.text)

    var GAMEPLAY_TABLE = {
        "MAG1": str(data.ability_magnitude), 
        "MAG2": str(data.ability_magnitude_2), 
        "MAG3": str(data.ability_magnitude_3), 
        "SCORE": str("+", data.plus_score, " Score"), 
        "ORE": str("+", data.plus_ore, " Ore"), 
        "ENERGY": str("+", data.plus_energy, " Energy"), 
        "CARDS": str("+", data.plus_cards, " Cards"), 
        "CARD_COUNT": str(data.plus_cards), 
        "OLD_MINE": str(clamp(data.ability_magnitude + (DeckManager.resources_in_deck() * data.ability_magnitude_2), data.ability_magnitude_3, 999)), 

        "P:": str("("), 
        ":P": str(")"), 
    }

    for PLACEHOLDER in GAMEPLAY_TABLE:
        description_label.text = description_label.text.replace(PLACEHOLDER, GAMEPLAY_TABLE[PLACEHOLDER])

func label_white():
    cost_label.set("theme_override_colors/font_color", "f7fff8")




func update_art():
    if not data: return

    match data.card_type:
        CardData.card_types.RESOURCE:
            type_label.text = "Resource"
            full_card_artwork.visible = true
            half_card_artwork.visible = false
            divider.visible = false
            description_label.visible = false
            full_card_artwork.texture = data.art

            if data.resource_type == CardData.resource_types.ORE:
                resource_value.visible = true
                score_value.visible = false
                base_art.texture = CARD_BASE_ART_RED
                if data.resource_value < RESOURCE_THRESHOLD_2: full_card_artwork.texture = ART_ORE_1
                elif data.resource_value >= RESOURCE_THRESHOLD_2 and data.resource_value < RESOURCE_THRESHOLD_3: full_card_artwork.texture = ART_ORE_2
                elif data.resource_value >= RESOURCE_THRESHOLD_3 and data.resource_value < RESOURCE_THRESHOLD_4: full_card_artwork.texture = ART_ORE_3
                elif data.resource_value >= RESOURCE_THRESHOLD_4 and data.resource_value < RESOURCE_THRESHOLD_5: full_card_artwork.texture = ART_ORE_4
                elif data.resource_value >= RESOURCE_THRESHOLD_5 and data.resource_value < RESOURCE_THRESHOLD_6: full_card_artwork.texture = ART_ORE_5
                elif data.resource_value >= RESOURCE_THRESHOLD_6: full_card_artwork.texture = ART_ORE_6
            elif data.resource_type == CardData.resource_types.SCORIUM:
                resource_value.visible = false
                score_value.visible = true
                base_art.texture = CARD_BASE_ART_YELLOW
                if data.resource_value < RESOURCE_THRESHOLD_2: full_card_artwork.texture = ART_SCORIUM_1
                elif data.resource_value >= RESOURCE_THRESHOLD_2 and data.resource_value < RESOURCE_THRESHOLD_3: full_card_artwork.texture = ART_SCORIUM_2
                elif data.resource_value >= RESOURCE_THRESHOLD_3 and data.resource_value < RESOURCE_THRESHOLD_4: full_card_artwork.texture = ART_SCORIUM_3
                elif data.resource_value >= RESOURCE_THRESHOLD_4 and data.resource_value < RESOURCE_THRESHOLD_5: full_card_artwork.texture = ART_SCORIUM_4
                elif data.resource_value >= RESOURCE_THRESHOLD_5 and data.resource_value < RESOURCE_THRESHOLD_6: full_card_artwork.texture = ART_SCORIUM_5
                elif data.resource_value >= RESOURCE_THRESHOLD_6: full_card_artwork.texture = ART_SCORIUM_6

        CardData.card_types.ACTION:
            type_label.text = "Action"
            full_card_artwork.visible = false
            half_card_artwork.visible = true
            divider.visible = true
            resource_value.visible = false
            score_value.visible = false
            description_label.visible = true
            half_card_artwork.texture = data.art
            base_art.texture = CARD_BASE_ART

        CardData.card_types.TARGET:
            type_label.text = "Tool"
            full_card_artwork.visible = false
            half_card_artwork.visible = true
            divider.visible = true
            resource_value.visible = false
            score_value.visible = false
            description_label.visible = true
            half_card_artwork.texture = data.art
            base_art.texture = CARD_BASE_ART_PURPLE

        CardData.card_types.UTILITY:
            type_label.text = "Utility"
            full_card_artwork.visible = false
            half_card_artwork.visible = true
            divider.visible = true
            cost_indicator.visible = false
            resource_value.visible = false
            score_value.visible = false
            description_label.visible = true
            half_card_artwork.texture = data.art

            if data.utility_type == CardData.utility_types.REMOVE:
                base_art.texture = CARD_BASE_ART_GREEN
            elif data.utility_type == CardData.utility_types.UPGRADE:
                base_art.texture = CARD_BASE_ART_GREEN




func show_stamp():
    if stamp.visible: return

    stamp.visible = true

    stamp.scale = Vector2.ZERO
    var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(stamp, "scale", Vector2(1.2, 1.2), 0.25)
    tween.tween_property(stamp, "scale", Vector2.ONE, 0.1)

func hide_stamp():
    stamp.visible = false

func update_stamp():
    stamp.visible = false

    if data.show_stamp_on_actions_played and DeckManager.count_actions_in_play() >= data.ability_magnitude: show_stamp()
