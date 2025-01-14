extends Node2D


func _on_BasicSpawner_spawned(object):
	object.position = Utils.random_box_position(Rect2(Vector2( - 105, - 75), Vector2(210, 150)))
