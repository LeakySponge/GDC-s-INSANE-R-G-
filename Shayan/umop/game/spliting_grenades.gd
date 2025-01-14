extends Node2D

@export var orbs_for_bonus := 0


func _on_BasicSpawner_spawned(object):
	object.position = Utils.random_box_position(Rect2(Vector2( - 170, - 130), Vector2(340, 260)), true)
	object.velocity = - object.position.normalized() * randf_range(105, 165)

	if Game.level._score > orbs_for_bonus:
		object.follow = true
