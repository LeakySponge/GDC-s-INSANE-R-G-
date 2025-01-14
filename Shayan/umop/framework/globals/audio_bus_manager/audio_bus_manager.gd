extends Node

var global_volumes = {"SFX": 4, "Music": 4}



func set_volume_linear(bus_name: String, value: float) -> void :
	var bus_id: = AudioServer.get_bus_index(bus_name)
	var volume_db: = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_id, volume_db)


func get_volume_linear(bus_name: String) -> float:
	var bus_id: = AudioServer.get_bus_index(bus_name)
	var normalized: = db_to_linear(AudioServer.get_bus_volume_db(bus_id))

	return normalized
