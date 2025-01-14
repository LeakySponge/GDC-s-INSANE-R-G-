extends Control
class_name ShopCard

const PRICE_TAG_HUGE = preload("res://Art/PriceTagHuge.png")
const PRICE_TAG_LARGE = preload("res://Art/PriceTagLarge.png")

const TEXT_POPUP = preload("res://UI/text_popup.tscn")

@export var data: CardData

@onready var visual: CardVisual = $Visual
@onready var price_tag: TextureRect = $PriceTag
@onready var price_label: Label = $PriceTag / Label

var purchased = false
var is_moused_over: = false

func _ready() -> void :
    if data: initialize(data)

func initialize(data_in: CardData):
    data = data_in
    visual.data = data
    visual.create_visual()
    visual.label_white()

    calculate_price()
    update_pricetag()
    SignalBus.ore_spent.connect(update_pricetag)


    if data.card_type == CardData.card_types.UTILITY and data.utility_type == CardData.utility_types.REMOVE:
        SignalBus.remove_purchased.connect(flag_as_purchased)
    if data.card_type == CardData.card_types.UTILITY and data.utility_type == CardData.utility_types.UPGRADE:
        SignalBus.upgrade_purchased.connect(flag_as_purchased)

func _on_button_mouse_entered() -> void :
    if purchased: return

    is_moused_over = true
    AudioBus.card_moused_over.emit()
    visual.pop_up()

func _on_button_mouse_exited() -> void :
    if purchased: return

    is_moused_over = false
    visual.pop_down()

func _on_button_pressed() -> void :
    if purchased: return

    if data.final_price > GameLogic.ore_collected:
        not_enough_money()
        return
    buy()

    visual.pop_down()

func _physics_process(delta: float) -> void :
    if purchased:
        visual.rotate_stop()
        return

    if is_moused_over: visual.rotate()
    else: visual.rotate_idle()

func buy():
    if data.card_type == CardData.card_types.UTILITY and data.utility_type == CardData.utility_types.REMOVE:
        buy_removal()
        return

    if data.card_type == CardData.card_types.UTILITY and data.utility_type == CardData.utility_types.UPGRADE:
        buy_upgrade()
        return

    Utilities.add_particles("res://Particles/resource_particles.tscn", global_position + pivot_offset).reparent(Global.particle_folder_cv)
    visual.empty()
    price_tag.visible = false
    purchased = true
    SignalBus.card_purchased.emit(data)
    AudioBus.card_purchased.emit()

func buy_removal():
    SignalBus.ask_to_remove_card.emit()
    AudioBus.button_clicked.emit()

func buy_upgrade():
    SignalBus.ask_to_upgrade_card.emit()
    AudioBus.button_clicked.emit()

func flag_as_purchased():
    visual.empty()
    price_tag.visible = false
    purchased = true
    Utilities.add_particles("res://Particles/resource_particles.tscn", global_position + pivot_offset).reparent(Global.particle_folder_cv)

func update_pricetag():
    price_label.text = str(data.final_price)

    if data.final_price > GameLogic.ore_collected: price_label.set("theme_override_colors/font_color", "d43a2b")
    else: price_label.set("theme_override_colors/font_color", "f7fff8")

    if data.final_price >= 100:
        price_tag.texture = PRICE_TAG_HUGE

func calculate_price():
    if data.card_type == CardData.card_types.UTILITY and data.utility_type == CardData.utility_types.REMOVE:
        data.final_price = GameLogic.shop_card_removal_cost
    elif data.card_type == CardData.card_types.UTILITY and data.utility_type == CardData.utility_types.UPGRADE:
        data.final_price = GameLogic.shop_card_upgrade_cost
    else:
        data.final_price = floori(data.base_price + (GameLogic.shop_inflation_flat_increase * GameLogic.expedition_number) + (data.base_price * GameLogic.shop_inflation_scaling * GameLogic.expedition_number))

func not_enough_money():
    AudioBus.not_enough_energy.emit()
    visual.flash_red()
    var new_popup: TextPopup = TEXT_POPUP.instantiate()
    new_popup.create("not enough ore!", get_global_mouse_position(), Global.particle_folder_cv)
    await visual.pop_down()
    if is_moused_over: visual.pop_up()
