extends Node2D

@export var spawn_duration := 1.0
@export var rotation_speed := 600

var Enemy: = preload("res://game/Enemy.tscn")

@onready var timer: = $Timer


func _ready():
	timer.wait_time = spawn_duration
	timer.start()


func _process(delta):
	rotation_degrees += delta * rotation_speed


func _on_Timer_timeout():
	var enemy = Enemy.instantiate()
	enemy.position = position
	Game.add_to_level(enemy)
	queue_free()
