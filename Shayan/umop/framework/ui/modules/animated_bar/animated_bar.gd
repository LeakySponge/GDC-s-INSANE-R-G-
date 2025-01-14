extends CenterContainer

signal value_topped
signal value_bottomed

@export var blink_duration := 1.0 / 60 * 4
@export var background_catchup_duration := 0.2
@export var starting_value := 10
@export var starting_max_value := 10

var value: = 0
var max_value: = 0

@onready var background_bar: = $BackgroundBar
@onready var foreground_bar: = $MarginContainer / ForegroundBar
@onready var blink: = $MarginContainer / Blink
@onready var label: = $MarginContainer / Label
@onready var tween: = $Tween



func _ready() -> void :
	value = starting_value
	max_value = starting_max_value

	_update_bar(false)
	_update_label()



func adjust_value(amount: int, animate = true) -> void :
	var new_value = clamp(value + amount, 0, max_value)

	if amount == 0 or value == new_value:
		animate = false

	value = new_value

	if value == 0:
		emit_signal("value_bottomed")
	if value == max_value:
		emit_signal("value_topped")

	_update_bar(animate)
	_update_label()


func set_value(new_value: int, new_max_value = - 1, animate = true) -> void :
	if value == new_value and (max_value == new_max_value or new_max_value == - 1):
		animate = false

	if new_max_value >= 0:
		max_value = new_max_value
	value = new_value

	if value == 0:
		emit_signal("value_bottomed")
	if value == max_value:
		emit_signal("value_topped")

	_update_bar(animate)
	_update_label()


func _update_bar(animate = true) -> void :
	foreground_bar.max_value = max_value
	foreground_bar.value = value

	if animate:
		var target = max(floor(foreground_bar.value / float(max(foreground_bar.max_value, 1)) * 100) - 2, 0)
		tween.interpolate_property(background_bar, "value", background_bar.value, target, background_catchup_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()

		blink.visible = true
		await get_tree().create_timer(blink_duration).timeout
		blink.visible = false


func _update_label() -> void :
	label.text = "%d/%d" % [value, max_value]
