extends CanvasLayer

@export var show_raw_cursor := false

var value: = 0.0

@onready var sprite: = $Sprite2D



func _ready() -> void :
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if show_raw_cursor else Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	value += delta * 7

	sprite.rotation += delta * 7

	sprite.scale = Vector2.ONE * (1 + (sin(value) + 1) / 2)


func _physics_process(_delta: float) -> void :
	sprite.position = sprite.get_global_mouse_position()
