extends Resource
class_name CardData





enum card_types{RESOURCE, ACTION, TARGET, SCORE, UTILITY}
enum resource_types{NONE, ORE, GEM, SCORIUM}
enum tool_types{RESOURCES, SAW, RADAR, WRENCH}
enum utility_types{NONE, REMOVE, UPGRADE}

@export_category("Attributes")
@export var name: String
@export_multiline var description: String
@export_multiline var notes: String

@export_category("Data")
@export var card_type: card_types
@export_group("Resources")
@export var resource_type: resource_types
@export var resource_value: int
@export_group("Tools")
@export var tool_requirements: tool_types
@export_group("Utilities")
@export var utility_type: utility_types

@export_category("Gameplay")
@export var energy_cost: int

@export var plus_cards: int
@export var plus_energy: int
@export var plus_ore: int
@export var plus_score: int
@export var plus_stored_energy: int
@export var ability_magnitude: int
@export var ability_magnitude_2: int
@export var ability_magnitude_3: int
@export var ability_1: CardAbility
@export var ability_2: CardAbility
@export var consumable: bool = false
@export var draw_resources_only: bool = false
@export var decrease_cost_on_resources_played: bool = false

@export_category("Shop")
@export var base_price: int
var final_price: int

@export_category("Display")
@export var art: Texture2D
@export var sound_effect_id: String
@export_group("Visual update conditions")
@export var update_visuals_on_deck_change: = false
@export var update_labels_on_card_clicked: = false
@export var update_stamp_on_cards_played: = false
@export var update_stamp_on_cards_drawn: = false
@export var show_stamp_on_actions_played: = false
@export var show_stamp_on_no_resources_in_hand = false

func play(card: Card):
    if ability_1 and not ability_2:
        return await ability_1.play(card)

    if ability_2 and not ability_1:
        return await ability_2.play(card)

    if not ability_1 or not ability_2:
        return
    if await ability_1.play(card) and await ability_2.play(card): return true
