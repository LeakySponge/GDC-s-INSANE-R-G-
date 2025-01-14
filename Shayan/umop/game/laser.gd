extends Node2D

enum {TOP, BOTTOM, LEFT, RIGHT}

@export var initial_wait := 2.0
@export var laser_duration := 2.0
@export var noise_rate := 1000.0
@export var segment_count := 12
@export var peak_height := 5
@export var setup_on_start := true
@export var use_initial_pos := false

var _noise: = FastNoiseLite.new()
var _noise_sample: = 0.0
var _shake_amount: = 0.0
var _shake_offset: = Vector2.ZERO

var do_triple: = false
var lasering: = false
var setup_ready: = false
var LaserParticles: = preload("res://game/LaserParticles.tscn")

@onready var sprite: = $Sprite2D
@onready var sprite_2: = $Sprite2
@onready var laser_line: = $LaserLine
@onready var laser_line_2: = $LaserLine2
@onready var hitbox: = $Hitbox
@onready var collision_shape: = $Hitbox / CollisionShape2D
@onready var spawn_sound: = $SpawnSound
@onready var impact_sound: = $ImpactSound
@onready var cont_sound: = $ContSound
@onready var tween: = $Tween
@onready var target_line: = $TargetLine
@onready var triple_sound: = $TripleSound


func _ready():
	sprite.rotation = randf() * PI * 2
	sprite_2.rotation = randf() * PI * 2

	tween.interpolate_property(sprite, "scale", Vector2.ZERO, Vector2.ONE, 0.4, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.interpolate_property(sprite_2, "scale", Vector2.ZERO, Vector2.ONE, 0.4, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.interpolate_property(target_line, "modulate", Color("#ffffff00"), Color("#ffffff71"), 0.75, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


	if setup_on_start:
		setup()


func _process(delta):
	if setup_ready:
		_shake_amount = lerp(0.5, _shake_amount, pow(2, - 10 * delta))
		_noise_sample += delta * noise_rate

		laser_line.clear_points()
		laser_line_2.clear_points()
		if lasering:
			var segment_length = (sprite_2.position - sprite.position) / segment_count
			var perp = segment_length.normalized().rotated(PI / 2)
			for i in segment_count + 1:
				var point_pos = sprite.position + segment_length * i
				var point_pos_2 = sprite.position + segment_length * i
				if i > 0 and i <= segment_count:
					point_pos += perp * _noise.get_noise_2d(_noise_sample, i * 16) * peak_height * _shake_amount * clamp(i / 8.0, 0, 1) * clamp((segment_count + 1 - i) / 8.0, 0, 1)
					
				laser_line.add_point(point_pos)
				laser_line_2.add_point(point_pos)

			sprite.rotation += delta * 2.5 * 8
			sprite_2.rotation += delta * 3 * 8
		else:
			sprite.rotation += delta * 2.5 * 2
			sprite_2.rotation += delta * 3 * 2



func setup():
	setup_ready = true
	spawn_sound.play_detached()

	if not use_initial_pos:
		var spawn_dir = randi() % 4
		var spawn_dir_2
		match spawn_dir:
			TOP:
				sprite.position = Vector2(randf_range( - 95, 95), - 90)
				spawn_dir_2 = BOTTOM
			BOTTOM:
				sprite.position = Vector2(randf_range( - 95, 95), 90)
				spawn_dir_2 = TOP
			LEFT:
				sprite.position = Vector2( - 130, randf_range( - 65, 65))
				spawn_dir_2 = RIGHT
			RIGHT:
				sprite.position = Vector2(130, randf_range( - 65, 65))
				spawn_dir_2 = LEFT

		match spawn_dir_2:
			TOP:
				sprite_2.position = Vector2(randf_range( - 95, 95), - 90)
			BOTTOM:
				sprite_2.position = Vector2(randf_range( - 95, 95), 90)
			LEFT:
				sprite_2.position = Vector2( - 130, randf_range( - 65, 65))
			RIGHT:
				sprite_2.position = Vector2(130, randf_range( - 65, 65))

	hitbox.position = sprite.position + (sprite_2.position - sprite.position) / 2
	hitbox.rotation = (sprite_2.position - sprite.position).angle()
	collision_shape.shape.extents.x = sprite.position.distance_to(sprite_2.position) / 2

	target_line.show()
	target_line.clear_points()
	target_line.add_point(sprite.position)
	target_line.add_point(sprite_2.position)


	$DropShadow.update_thingy()
	$DropShadow2.update_thingy()

	
	


	await get_tree().create_timer(initial_wait, false).timeout
	_shake_amount = 5
	lasering = true
	collision_shape.set_deferred("disabled", false)
	impact_sound.play_detached()
	cont_sound.play_detached()
	if do_triple:
		triple_sound.play_detached()
	target_line.hide()

	await get_tree().create_timer(laser_duration, false).timeout
	collision_shape.set_deferred("disabled", true)
	lasering = false
	var laser_particles = LaserParticles.instantiate()
	laser_particles.position = hitbox.position
	laser_particles.rotation = hitbox.rotation
	laser_particles.amount = randf_range(4, 10)
	
	laser_particles.emission_rect_extents = Vector2(sprite.position.distance_to(sprite_2.position) / 2, 1)
	laser_particles.emitting = true
	Game.add_to_level(laser_particles)


	await get_tree().create_timer(0.9, false).timeout

	tween.interpolate_property(sprite, "scale", Vector2.ONE * 1.25, Vector2.ZERO, 0.15, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(sprite_2, "scale", Vector2.ONE * 1.25, Vector2.ZERO, 0.15, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	await tween.tween_all_completed

	queue_free()
