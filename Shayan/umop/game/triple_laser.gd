extends Node2D

enum {TOP, BOTTOM, LEFT, RIGHT}

@onready var laser_1: = $Laser
@onready var laser_2: = $Laser2
@onready var laser_3: = $Laser3


func _ready():
	var pos1
	var pos2
	var pos3

	var spawn_dir = randi() % 4
	var spawn_dir_2
	match spawn_dir:
		TOP:
			pos1 = Vector2(randf_range( - 130, 130), - 90)
			spawn_dir_2 = BOTTOM
		BOTTOM:
			pos1 = Vector2(randf_range( - 130, 130), 90)
			spawn_dir_2 = TOP
		LEFT:
			pos1 = Vector2( - 130, randf_range( - 90, 90))
			spawn_dir_2 = RIGHT
		RIGHT:
			pos1 = Vector2(130, randf_range( - 90, 90))
			spawn_dir_2 = LEFT

	match spawn_dir_2:
		TOP:
			pos2 = Vector2(randf_range( - 95, 95), - 90)
		BOTTOM:
			pos2 = Vector2(randf_range( - 95, 95), 90)
		LEFT:
			pos2 = Vector2( - 130, randf_range( - 65, 65))
		RIGHT:
			pos2 = Vector2(130, randf_range( - 65, 65))

	var spawn_dir_3
	if spawn_dir == TOP or spawn_dir == BOTTOM:
		if randi() % 2 == 0:
			spawn_dir_3 = LEFT
		else:
			spawn_dir_3 = RIGHT
	else:
		if randi() % 2 == 0:
			spawn_dir_3 = TOP
		else:
			spawn_dir_3 = BOTTOM

	match spawn_dir_3:
		TOP:
			pos3 = Vector2(randf_range( - 95, 95), - 90)
		BOTTOM:
			pos3 = Vector2(randf_range( - 95, 95), 90)
		LEFT:
			pos3 = Vector2( - 130, randf_range( - 65, 65))
		RIGHT:
			pos3 = Vector2(130, randf_range( - 65, 65))

	laser_1.sprite.position = pos1
	laser_1.sprite_2.position = pos2
	laser_2.sprite.position = pos2
	laser_2.sprite_2.position = pos3
	laser_3.sprite.position = pos3
	laser_3.sprite_2.position = pos1

	laser_1.setup()
	laser_2.setup()
	laser_3.setup()

	laser_1.sprite.modulate = Color("f77622")
	
	laser_1.sprite_2.hide()
	laser_2.sprite.modulate = Color("f77622")
	
	laser_2.sprite_2.hide()
	laser_3.sprite.modulate = Color("f77622")
	
	
	laser_3.sprite_2.hide()

	laser_1.do_triple = true

	laser_1.cont_sound.random_audio_player.volume_db = - 28
	laser_2.cont_sound.random_audio_player.volume_db = - 28
	laser_3.cont_sound.random_audio_player.volume_db = - 28




