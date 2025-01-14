extends Node2D

@export var bullet_speed := 550

var Bullet: = preload("res://game/Bullet.tscn")

@onready var sprite: = $Sprite2D

func _process(delta):
	var mouse_direction: = get_global_mouse_position() - global_position
	rotation = atan2(mouse_direction.y, mouse_direction.x)

	sprite.flip_v = abs(rotation) > PI / 2


func shoot():
	var bullet = Bullet.instantiate()
	bullet.position = global_position
	bullet.velocity = Vector2(cos(rotation), sin(rotation)) * bullet_speed
	Game.add_to_level(bullet)
