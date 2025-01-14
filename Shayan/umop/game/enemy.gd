extends Node2D

signal died

@export var max_health := 5
@export var friction := 10

var velocity: = Vector2.ZERO

@onready var health: = max_health
@onready var squasher: = $Squasher


func _ready():
	squasher.squash()


func _physics_process(delta):
	if position.x < - 115 or position.x > 115 or position.y < - 82 or position.y > 82:
		die()
		
	velocity = lerp(Vector2.ZERO, velocity, pow(2, - friction * delta))

	position += velocity * delta



func die():
	queue_free()
	emit_signal("died")


func _on_Hurtbox_area_entered(area: Area2D):
	area.owner.queue_free()
	health -= 1
	velocity += area.owner.velocity.normalized() * 100
	if health <= 0:
		die()
