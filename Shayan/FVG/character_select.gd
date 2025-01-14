extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player1 = str("res://combat/characters/terry/terry.tscn")
	Global.stage = Global.stages["training"]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("service 1"):
		get_tree().change_scene_to_file("res://PFTNF.tscn")
