extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player1 = str("res://combat/characters/terry/terry.tscn")
	Global.stage = Global.stages["training"]
	Console.add_command("startmatch", start_match, [1, 2])

func start_match(char1, char2):
	get_tree().change_scene_to_file("res://PFTNF.tscn")
