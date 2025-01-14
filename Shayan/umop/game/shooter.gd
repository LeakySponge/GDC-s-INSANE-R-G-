extends Node2D

@export var shot_count := 8
@export var lock_duration := 0.35
@export var bullet_speed := 150.0
@export var last_timer_duration := 0.5
@export var line_move_duration := 0.1
@export var follow_bullets := false


var lock_directions: = []
var line_textures: = []
var locks_left: = 0
var locking: = true
var please_fix: = 0

var Bullet: = preload("res://game/Bullet.tscn")
var Texture1: = preload("res://game/line_texture.png")
var Texture2: = preload("res://game/line_texture_2.png")

@onready var timer: = $Timer
@onready var squasher: = $Squasher
@onready var spawn_sound: = $SpawnSound
@onready var lock_sound: = $LockSound
@onready var shoot_sound: = $ShootSound
@onready var target_line: = $Cont / Line2D
@onready var target_line_2: = $Cont / Line2D2
@onready var target_lines: = $TargetLines
@onready var line_move_timer: = $LineMoveTimer
@onready var shoot_sound_2: = $ShootSound2
@onready var tween: = $Tween
@onready var sprite: = $Sprite2D



func setup():
	line_textures.append(Texture1)
	line_textures.append(Texture2)

	spawn_sound.play_detached()
	locks_left = shot_count

	line_move_timer.wait_time = line_move_duration
	

	squasher.squash()
	await get_tree().create_timer(lock_duration / 2, false).timeout

	timer.wait_time = lock_duration
	timer.start()


func _physics_process(delta):
	if locking and Game.player and is_instance_valid(Game.player):
		$Sprite2D.rotation = (Game.player.position - position).angle()


func shoot():
	for dir in lock_directions:
		Game.camera.shake(2)
		$Sprite2D.rotation = dir.angle()
		target_lines.get_child(0).queue_free()
		squasher.squash()
		shoot_sound.play_detached()
		shoot_sound_2.play_detached()
		var bullet = Bullet.instantiate()
		bullet.position = position + dir.normalized() * 10
		bullet.velocity = dir * bullet_speed * randf_range(0.9, 1.1)
		bullet.follow = follow_bullets
		Game.add_to_level(bullet)
		await get_tree().create_timer(0.1, false).timeout

	
	
	

	await get_tree().create_timer(last_timer_duration, false).timeout

	tween.interpolate_property(sprite, "scale", Vector2(0.25, 1.75), Vector2(1.75, 0.0), 0.08, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	await tween.tween_all_completed

	queue_free()


func _on_Timer_timeout():
	please_fix += 1

	if locks_left <= 0:
		locking = false
		timer.stop()
		shoot()
	else:
		squasher.stretch()
		lock_sound.play_detached()
		locks_left -= 1
		var dir
		if Game.player and is_instance_valid(Game.player):
			dir = position.direction_to(Game.player.position)
		else:
			dir = - position.normalized()
		var dir_line = Line2D.new()
		dir_line.width = target_line.width
		dir_line.default_color = target_line.default_color
		
		
		if (please_fix % 2) == 0:
			dir_line.texture = target_line.texture
		else:
			dir_line.texture = target_line_2.texture
		dir_line.texture_mode = target_line.texture_mode
		tween.interpolate_property(dir_line, "modulate", Color("#ffffff00"), Color("#ffffff71"), 0.35, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		tween.start()
		target_lines.add_child(dir_line)
		dir_line.add_point(Vector2.ZERO)
		dir_line.add_point(dir * 500)
		lock_directions.append(dir)


func _on_LineMoveTimer_timeout():
	for i in target_lines.get_child_count():
		target_lines.get_children()[i].texture = line_textures[i % 2]
	line_textures.invert()
