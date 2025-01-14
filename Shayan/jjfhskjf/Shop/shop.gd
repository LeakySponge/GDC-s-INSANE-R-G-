extends Control
class_name Shop

@export var shop_pool: Array[CardData]

@onready var card_shop = $"Shop Container/Play Area/CardShop"
@onready var reroll_button: Button = $"Shop Container/Play Area/Reroll"
@onready var shop_container = $"Shop Container"
@onready var card_pile_display: CardPileDisplay = $CardPileDisplay

@onready var particle_folder: Node2D = $"Particle Folder"
@onready var particle_folder_cv: CanvasLayer = $"Particle Folder CV"

@onready var go_button: Button = $"Shop Container/Play Area/Go"

const SHOP_CARD_DISPLAY = preload("res://Shop/shop_card_display.tscn")

const shop_card_amount: int = 4

const starting_reroll_cost: int = 3
const reroll_increase: int = 2

var current_reroll_cost: = starting_reroll_cost

var removing: = false
var upgrading: = false

func _ready():
    Global.particle_folder = particle_folder
    Global.particle_folder_cv = particle_folder_cv

    SignalBus.shop_entered.emit()

    SignalBus.ask_to_remove_card.connect(show_remove_deck)
    SignalBus.ask_to_upgrade_card.connect(show_upgrade_deck)

    SignalBus.ask_to_show_deck.connect(show_deck)
    card_pile_display.button.pressed.connect(close_display)

    SignalBus.card_inspected.connect(on_card_inspected)

    SignalBus.ore_spent.connect(on_ore_spent)

    update_reroll_button_text()
    stock_card_shop()

func stock_card_shop():
    for card in card_shop.get_children():
        card.queue_free()

    shop_pool.shuffle()
    for i in shop_card_amount:
        var new_shop_card: ShopCard = SHOP_CARD_DISPLAY.instantiate()
        card_shop.add_child(new_shop_card)
        new_shop_card.initialize(shop_pool[i].duplicate())

func _on_reroll_pressed():
    reroll_button.release_focus()
    if GameLogic.ore_collected < current_reroll_cost:
        reroll_button.release_focus()
        return

    GameLogic.ore_collected -= current_reroll_cost
    SignalBus.ore_spent.emit()
    StatsTracker.ore_spent += current_reroll_cost
    StatsTracker.times_rerolled += 1

    stock_card_shop()
    current_reroll_cost += reroll_increase
    update_reroll_button_text()
    reroll_button.release_focus()
    AudioBus.button_clicked.emit()

func update_reroll_button_text():
    reroll_button.text = str("reroll: ", str(current_reroll_cost))
    if GameLogic.ore_collected < current_reroll_cost: reroll_button.disabled = true

func display_deck():
    shop_container.visible = false
    card_pile_display.visible = true

func show_deck():
    display_deck()
    card_pile_display.display(DeckManager.deck, "Deck")

func show_remove_deck():
    removing = true
    card_pile_display.display(DeckManager.deck, "Choose a card to remove.")
    display_deck()

func show_upgrade_deck():
    upgrading = true
    card_pile_display.display_resources(DeckManager.deck, "Choose a resource to upgrade.")
    display_deck()

func close_display():
    shop_container.visible = true
    card_pile_display.visible = false
    removing = false
    upgrading = false

func on_card_inspected(data: CardData):
    if removing:
        DeckManager.deck.erase(data)
        GameLogic.ore_collected -= GameLogic.shop_card_removal_cost
        StatsTracker.ore_spent += GameLogic.shop_card_removal_cost
        StatsTracker.utilities_bought += 1
        StatsTracker.dynamite_bought += 1
        GameLogic.shop_card_removal_cost += GameLogic.shop_card_removal_cost_increase
        SignalBus.remove_purchased.emit()
        SignalBus.ore_spent.emit()
        AudioBus.card_removed.emit()

        close_display()
        return
    if upgrading:
        data.resource_value += GameLogic.shop_card_upgrade_amount
        GameLogic.ore_collected -= GameLogic.shop_card_upgrade_cost
        StatsTracker.ore_spent += GameLogic.shop_card_upgrade_cost
        StatsTracker.utilities_bought += 1
        StatsTracker.hammers_bought += 1
        StatsTracker.resources_improved += GameLogic.shop_card_upgrade_amount
        GameLogic.shop_card_upgrade_cost += GameLogic.shop_card_upgrade_cost_increase
        SignalBus.ore_spent.emit()
        SignalBus.upgrade_purchased.emit()
        AudioBus.card_upgraded.emit()
        close_display()
        return

func _on_go_pressed():
    go_button.disabled = true
    LoadingManager.go_to_scene("res://Map/map.tscn", "navigating map...", Loader.COLORS.BLUE)
    AudioBus.button_clicked.emit()

func _on_go_mouse_entered():
    AudioBus.button_mouse_over.emit()

func _on_reroll_mouse_entered():
    if reroll_button.disabled: return
    AudioBus.button_mouse_over.emit()

func on_ore_spent():
    update_reroll_button_text()
