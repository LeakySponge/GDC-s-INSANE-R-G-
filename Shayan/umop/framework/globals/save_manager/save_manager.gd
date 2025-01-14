extends Node

@export var reset_data_on_start := false

var data = {"hiscore": 0, "fullscreen": false, "screen_shake": true, "moving_background": true}



func _ready() -> void :
	if reset_data_on_start:
		save_data()

	load_data()



func save_data() -> void :
	var file: = File.new()
	file.open("user://save.dat", File.WRITE)
	file.store_string(var_to_str(data))
	file.close()


func load_data() -> void :
	var file: = File.new()
	if not file.file_exists("user://save.dat"):
		save_data()
		return
	file.open("user://save.dat", File.READ)
	var new_data = str_to_var(file.get_as_text())
	file.close()

	for k in new_data.keys():
		data[k] = new_data[k]


func reset_data() -> void :
	data.hiscore = 0
	save_data()
