extends Node2D

@export var orbs_for_bonus := 0

var bonus_done: = false


func _process(delta):
	if not bonus_done and Game.level._score > orbs_for_bonus:
		bonus_done = true
		Game.level.spawn_plus_label("+HOMING GRENADE")


func _on_BasicSpawner_spawned(object):
	
	
	object.position = Utils.random_box_position(Rect2(Vector2( - 170, - 130), Vector2(340, 260)), true)
	object.velocity = - object.position.normalized() * randf_range(105, 165)

	if Game.level._score > orbs_for_bonus:

		object.follow = true
