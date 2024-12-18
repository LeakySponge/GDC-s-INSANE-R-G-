extends Node2D

signal game_start


# List of Microgame Scenes
var microgameScenes = [
	preload("res://Shayan/Micro1/Micro1.tscn")
]

# Current Active Game
var daCurrentGame = null

func _ready() -> void:
	Global.diffy =  1
	Global.current_game = 1


func _on_game_start() -> void:
	pass # Replace with function body.


func spawn_random_microgame():
	# Clean up the previous microgame
	
	if daCurrentGame:
		daCurrentGame.queue_free()
	
	
	# Randomly pick a game
	var random_index = randi() % microgameScenes.size()
