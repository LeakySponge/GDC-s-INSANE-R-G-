extends Node2D

@export var max_angle := 3
@export var move_multiplier := 0.5
@export var follow_friction := 15.0

var value: = 0.0
var target_pos: = Vector2.ZERO
var fake_pos: = Vector2.ZERO


func _process(delta):
	

	
	

	if Game.player and is_instance_valid(Game.player):
		target_pos = Game.player.position

	fake_pos = lerp(target_pos, fake_pos, pow(2, - follow_friction * delta))

	if Settings.moving_background:
		position = fake_pos * move_multiplier
	else:
		position = Vector2.ZERO
