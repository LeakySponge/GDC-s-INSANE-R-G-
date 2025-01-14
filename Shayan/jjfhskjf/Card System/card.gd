\
extends Control
class_name Card

var slot: CardSlot

@onready var visual: CardVisual = $CardVisual
@onready var card_state_machine: CardStateMachine = $CardStateMachine
@onready var button: Button = $Button

@export var data: CardData

var targets = []


const DRAG_MOVEMENT_SPEED: = 0.25
const DRAG_ROTATION_SPEED: = 0.15

const DISCARD_SPEED: = 0.25


var is_selected: = false
var is_moused_over: = false
var is_discarded: = false
var is_played: = false


signal selected
signal deselected





const CARD_DRAW_POSITION: = Vector2(30, 800)
const CARD_DISCARD_POSITION: = Vector2(1680, 760)



func _ready() -> void :
    if data: initialize(data)

func initialize(data_in: CardData) -> void :
    if not data_in: return
    data = data_in
    visual.card = self
    visual.data = data
    visual.create_visual()

    SignalBus.deck_changed.connect(on_deck_changed)
    SignalBus.card_played.connect(on_card_played)
    SignalBus.card_clicked.connect(on_card_clicked)


    if card_state_machine: card_state_machine.init(self)

func _input(event: InputEvent):
    if card_state_machine: card_state_machine.on_input(event)

func _process(delta):
    if card_state_machine: card_state_machine.on_process(delta)

func _physics_process(delta):
    if card_state_machine: card_state_machine.on_physics_process(delta)

func on_deck_changed():
    if data.update_visuals_on_deck_change: visual.update_labels()

func on_card_played(_card: Card):
    if data.update_stamp_on_cards_played: visual.update_stamp()

func on_card_clicked(card: Card):

    if data.decrease_cost_on_resources_played and card.data.card_type == CardData.card_types.RESOURCE:
        data.energy_cost = clamp(data.ability_magnitude_2 - DeckManager.count_resources_in_play() - 1, 0, 99)







    if data.update_labels_on_card_clicked: visual.update_labels()








func _on_button_mouse_entered() -> void :
    if is_played: return

    is_moused_over = true

    if card_state_machine: card_state_machine.on_mouse_entered()

func _on_button_mouse_exited() -> void :
    if is_played: return

    is_moused_over = false

    if card_state_machine: card_state_machine.on_mouse_exited()

func _on_button_gui_input(event: InputEvent) -> void :
    if card_state_machine: card_state_machine.on_gui_input(event)











func check_if_contains_mouse() -> bool:
    return is_moused_over

func draw():

    if data.decrease_cost_on_resources_played:
        data.energy_cost = clamp(data.ability_magnitude_2 - DeckManager.count_resources_in_play(), 0, 99)
        visual.update_labels()











    global_position = CARD_DRAW_POSITION

    visual.pop_flat()



func discard():
    card_state_machine.current_state.transition_requested.emit(card_state_machine.current_state, CardState.State.DISCARD)

















func deselect():


    is_selected = false

    pivot_offset = Vector2(size.x / 2, size.y / 2)

    deselected.emit()
    targets.clear()
    SignalBus.card_deselected.emit(self)
    AudioBus.card_deselected.emit()
    card_state_machine.current_state.transition_requested.emit(card_state_machine.current_state, CardState.State.BASE)

    visual.pop_down()
    visual.rotate_idle()

    await get_tree().create_timer(0.15, false).timeout
    z_index = 0

func play(subtract_energy: bool, play_sfx: bool):
    if is_played: return
    if not await data.play(self): return

    SignalBus.card_clicked.emit(self)

    if subtract_energy and data.energy_cost > 0:
        SignalBus.subtract_energy.emit(data.energy_cost)

    if play_sfx:
        if data.card_type == CardData.card_types.RESOURCE:
            AudioBus.resource_played.emit()
        if data.card_type == CardData.card_types.ACTION:
            AudioBus.play_sound_with_id.emit(data.sound_effect_id)
        if data.card_type == CardData.card_types.TARGET:
            AudioBus.play_sound_with_id.emit(data.sound_effect_id)

    if data.card_type == CardData.card_types.RESOURCE:
        Utilities.add_particles("res://Particles/resource_particles.tscn", global_position + pivot_offset)
        Utilities.add_particles("res://Particles/resource_particles.tscn", global_position + pivot_offset).reparent(Global.particle_folder_cv)

    is_played = true
    targets.clear()
    await visual.flash()

    if data.plus_cards > 0:
        SignalBus.draw_card.emit(data.plus_cards)

    if data.draw_resources_only:
        SignalBus.draw_resources.emit(data.ability_magnitude)

    if data.consumable:
        DeckManager.deck.erase(data)

    card_state_machine.current_state.transition_requested.emit(card_state_machine.current_state, CardState.State.BASE)

    track_stats()

    queue_free()
    slot.free()


    if data.decrease_cost_on_resources_played:
        data.energy_cost = clamp(data.ability_magnitude_2, 0, 99)
        visual.update_labels()

    SignalBus.card_played.emit(self)

func track_stats():
    StatsTracker.cards_played += 1

    if data.card_type == CardData.card_types.RESOURCE: StatsTracker.resources_played += 1
    if data.card_type == CardData.card_types.ACTION: StatsTracker.actions_played += 1
    if data.card_type == CardData.card_types.TARGET: StatsTracker.tools_played += 1



func increase_resource_value(amount: int):
    var original_amount: = data.resource_value
    data.resource_value += amount
    data.resource_value = clamp(data.resource_value, 1, 99)
    visual.update_visuals()
    return original_amount - data.resource_value

func adjust_energy_cost(amount: int):
    data.energy_cost = clamp(data.energy_cost + amount, -99, 99)
    visual.update_labels()

func add_resource_value():
    if data.resource_type == CardData.resource_types.ORE:
        SignalBus.add_ore.emit(data.resource_value)
    if data.resource_type == CardData.resource_types.SCORIUM:
        SignalBus.add_score.emit(data.resource_value)
