extends Node2D

signal game_start
signal _on_completed_game


# List of Microgame Scenes
var microgameScenes = [
	preload("res://Shayan/Micro1/Micro1.tscn")
]

# Current Active Game
var daCurrentGame = null

func _ready() -> void:
	Global.diffy =  1
	Global.current_game = 1
	
	spawn_random_microgame()


func _on_game_start() -> void:
	pass # Replace with function body.


func spawn_random_microgame():
	# Clean up the previous microgame
	
	if daCurrentGame:
		daCurrentGame.queue_free()
	
	
	# Randomly pick a game
	var random_index = randi() % microgameScenes.size()
	var microgameScene = microgameScenes[random_index]
	
	# Freakin Instance it & ADD IT TO THE PLANT
	daCurrentGame = microgameScene.instantiate()
	add_child(daCurrentGame)
	
	
	if daCurrentGame.has_method("completed_game"):
		daCurrentGame.connect("completed_game", Callable(self, "_on_completed_game"))


func _on__on_completed_game() -> void:
	
	spawn_random_microgame()
