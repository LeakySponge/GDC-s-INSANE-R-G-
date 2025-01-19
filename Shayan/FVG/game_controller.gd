class_name GameController extends Node






#func _on_child_entered_tree(node: Node) -> void:
	##init_battle()
	#SignalManager.start_intros.emit()



#func init_battle():
	#add_characters()
	#add_stage()


# Later for more stages
func add_stage():
	pass



# Tis for later when more characters are added
func add_characters():
	#var load_player1 = preload("res://combat/characters/terry/terry.tscn")
	#var loaded_player1 = load_player1.instantiate()
	#add_child.call_deferred(loaded_player1)
	#loaded_player1.global_position = Vector3(100, 100, 100)
	#print(spawn_position)
	#print($Terry.global_position)
	pass


func _ready() -> void:
	SignalManager.start_fight.connect(on_start_fight)
	SignalManager.start_intros.emit()
	print("sent start_intro")

func on_start_fight():
	pass
