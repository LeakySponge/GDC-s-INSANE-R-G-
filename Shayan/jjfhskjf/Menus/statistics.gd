extends Control

@onready var ore_mined: Label = $"VBoxContainer/Ore Mined"
@onready var ore_spent: Label = $"VBoxContainer/Ore Spent"
@onready var score_collected: Label = $"VBoxContainer/Score Collected"
@onready var cards_improved: Label = $"VBoxContainer/Cards Improved"
@onready var deck_size: Label = $"VBoxContainer/Deck Size"
@onready var energy_spent: Label = $"VBoxContainer/Energy Spent"
@onready var cards_played: Label = $"VBoxContainer/Cards Played"
@onready var cards_drawn: Label = $"VBoxContainer/Cards Drawn"
@onready var cards_discarded: Label = $"VBoxContainer/Cards Discarded"
@onready var resources_played: Label = $"VBoxContainer/Resources Played"
@onready var actions_played: Label = $"VBoxContainer/Actions Played"
@onready var tools_played: Label = $"VBoxContainer/Tools Played"
@onready var hammers_bought: Label = $"VBoxContainer/Hammers Bought"
@onready var dynamite_bought: Label = $"VBoxContainer/Dynamite Bought"
@onready var times_rerolled: Label = $"VBoxContainer/Times Rerolled"

func _ready() -> void :
    ore_mined.text = ore_mined.text % StatsTracker.ore_mined
    ore_spent.text = ore_spent.text % StatsTracker.ore_spent
    score_collected.text = score_collected.text % StatsTracker.score_collected
    cards_improved.text = cards_improved.text % StatsTracker.resources_improved
    deck_size.text = deck_size.text % DeckManager.deck.size()
    energy_spent.text = energy_spent.text % StatsTracker.energy_spent
    cards_played.text = cards_played.text % StatsTracker.cards_played
    cards_drawn.text = cards_drawn.text % StatsTracker.cards_drawn
    cards_discarded.text = cards_discarded.text % StatsTracker.cards_discarded
    resources_played.text = resources_played.text % StatsTracker.resources_played
    actions_played.text = actions_played.text % StatsTracker.actions_played
    tools_played.text = tools_played.text % StatsTracker.tools_played
    hammers_bought.text = hammers_bought.text % StatsTracker.hammers_bought
    dynamite_bought.text = dynamite_bought.text % StatsTracker.dynamite_bought
    times_rerolled.text = times_rerolled.text % StatsTracker.times_rerolled
