extends CardAbility

const INSPECT_CARD = preload("res://Card System/inspect_card.tscn")

const ORE_PATH = "res://Card Resources/Ore.tres"
const SCORIUM_PATH = "res://Card Resources/Scorium.tres"

func play(card: Card) -> bool:
    var target: Card = card.targets[0]
    if not target.data.card_type == CardData.card_types.RESOURCE:
        card.deselect()
        return false

    var resource = null

    if target.data.resource_type == CardData.resource_types.ORE:
        resource = ResourceLoader.load(ORE_PATH)
    if target.data.resource_type == CardData.resource_types.SCORIUM:
        resource = ResourceLoader.load(SCORIUM_PATH)

    if not resource: return false

    var new_card: CardData = resource.duplicate()

    new_card.resource_value = card.data.ability_magnitude

    SignalBus.add_card.emit(new_card)
    SignalBus.add_to_draw_pile.emit(new_card)

    create_preview(card, new_card.duplicate())

    target.visual.flash_pop()

    return true

func create_preview(card: Card, data: CardData):
    var inspect_card: InspectCard = INSPECT_CARD.instantiate()
    Global.particle_folder_cv.add_child(inspect_card)
    inspect_card.initialize(data)
    inspect_card.global_position = Vector2(32, 424)
    inspect_card.lock()
    inspect_card.self_destruct()
    inspect_card.visual.pop_up_then_down_from_zero()

    await card.get_tree().create_timer(1.0, false).timeout

    inspect_card.visual.flip()
    inspect_card.visual.shrink()

    var tween: Tween = inspect_card.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween.tween_property(inspect_card, "global_position", Vector2(10, 740), 1.0)
