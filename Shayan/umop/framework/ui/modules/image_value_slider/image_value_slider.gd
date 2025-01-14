extends MarginContainer

signal value_changed(new_value)
signal on_focus
signal out_of_focus

@export var label_active_color: = Color.WHITE # (Color, RGBA)
@export var label_inactive_color: = Color.BLACK # (Color, RGBA)
@export var background_active_color: = Color.WHITE # (Color, RGBA)
@export var background_inactive_color: = Color.WHITE # (Color, RGBA)
@export var ActiveTexture: Texture2D = null
@export var InactiveTexture: Texture2D = null

@onready var background: = $Background
@onready var container: = $MarginContainer / HBoxContainer
@onready var label: = $MarginContainer / HBoxContainer / Label
@onready var slider: = $MarginContainer / HBoxContainer / Slider
@onready var pressed_sound: = $PressedSound
@onready var hover_sound: = $HoverSound
@onready var mouse_hovering: = false

var normalized_value: = 0.0

var _value: = 0
var _slider_array: = []
var _cached_pressed_value: = - 1
var _max_value: = 0
var _dragging: = false



func _ready() -> void :
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	label.connect("clicked", Callable(self, "_on_label_clicked"))
	label.connect("mouse_entered_raw", Callable(self, "_on_label_mouse_entered_raw"))

	container.modulate = label_inactive_color
	_slider_array = slider.get_children()
	_max_value = _slider_array.size()

	for i in _slider_array.size():
		_slider_array[i].index = i
		_slider_array[i].texture = InactiveTexture
		_slider_array[i].connect("clicked", Callable(self, "_on_slider_node_clicked"))
		_slider_array[i].connect("mouse_entered_indexed", Callable(self, "_on_slider_node_mouse_entered_indexed"))


func _gui_input(event: InputEvent) -> void :
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_dragging = false



func set_value(new_value: int, play_sound = true) -> void :
	if new_value == _value:
		return

	_cached_pressed_value = - 1

	_value = new_value
	for i in _slider_array.size():
		_slider_array[i].texture = ActiveTexture if i < _value + 1 else InactiveTexture

	_normalize_value()

	if play_sound:
		pressed_sound.play_detached(0.5 + (normalized_value * 0.5))

	emit_signal("value_changed", _value + 1)


func increase() -> void :
	set_value(int(min(_value + 1, _max_value - 1)))


func decrease() -> void :
	set_value(int(max(_value - 1, - 1)))


func _normalize_value() -> void :
	normalized_value = (_value + 1.0) / _max_value



func _on_mouse_entered() -> void :
	if not mouse_hovering:
		mouse_hovering = true
		hover_sound.play_detached()

	container.modulate = label_active_color
	background.color = background_active_color
	emit_signal("on_focus")


func _on_mouse_exited() -> void :
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()):
		mouse_hovering = false
		_dragging = false

	container.modulate = label_inactive_color
	background.color = background_inactive_color
	emit_signal("out_of_focus")


func _on_slider_node_clicked(index: int) -> void :
	set_value(index)
	_dragging = true


func _on_label_clicked() -> void :
	var temp = _value
	set_value(_cached_pressed_value)
	_cached_pressed_value = temp


func _on_label_mouse_entered_raw() -> void :
	if _dragging:
		set_value( - 1)


func _on_slider_node_mouse_entered_indexed(index: int) -> void :
	if _dragging:
		set_value(index)
