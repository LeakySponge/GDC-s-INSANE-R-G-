extends Label

@export var bounce_duration := 0.1
@export var bounce_height := 5

var _offset: = Vector2.ZERO
var _starting_position: = Vector2.ZERO

@onready var tween: = $Tween



func _ready() -> void :
	_starting_position = position



	



func bounce(amount = - 1.0) -> void :
	if amount < 0:
		amount = bounce_height

	
	
