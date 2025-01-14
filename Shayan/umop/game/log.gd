extends Node2D

var velocity: = Vector2.ZERO
var rotation_speed: = 0
var value: = 0.0

@onready var sprite: = $Node2D / Sprite2D
@onready var sprite_2: = $Node2D / Sprite2


func _physics_process(delta):
	position += velocity * delta
	rotation_degrees += rotation_speed * delta


func _process(delta):
	value += delta * 10

	sprite.position.x = sin(value) * 0.1
	sprite_2.position.x = - sin(value) * 0.1


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
