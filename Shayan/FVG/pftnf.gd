extends Node2D

signal start_match

@export var animation : AnimationPlayer

var characterPortraits = [
	preload("res://char select/portraits/amir.tres"),
	preload("res://char select/portraits/saimon.tres")
]


func _on_child_entered_tree(node: Node) -> void:
	var player1 = $player1
	var player2 = $player2
	animation.play("get_ready")
	

func transition():
	get_tree().change_scene_to_file("res://Main.tscn")
