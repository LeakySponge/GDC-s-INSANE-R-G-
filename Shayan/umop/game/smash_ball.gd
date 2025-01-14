extends Node2D

@export var explosion_time := 1.0
@export var tick_count := 3
@export var noise_rate := 1000.0
@export var explosion_duration := 0.25
@export var rotation_speed := 120
@export var laser_rotation_speed := 50

var value: = 0.0
var exploding: = false
var dying: = false
var base_scale: = Vector2.ONE * 1.5

var _noise: = FastNoiseLite.new()
var _noise_sample: = 0.0
var _shake_amount: = 0.0
var _shake_offset: = Vector2.ZERO

var area_rotation: = 0.0
var LaserParticles: = preload("res://game/LaserParticles.tscn")

@onready var blink_sprite: = $Blink
@onready var collision_shape: = $ExplosionArea / CollisionShape2D
@onready var collision_shape_2: = $ExplosionArea / CollisionShape2D2
@onready var timer: = $Timer
@onready var spawn_sound: = $SpawnSound
@onready var tick_sound: = $TickSound
@onready var explode_sound: = $ExplodeSound
@onready var tick_timer: = $TickTimer
@onready var sprite: = $Sprite2D
@onready var explosion_area: = $ExplosionArea
@onready var visuals: = $Visual
@onready var pre_visual: = $PreVisual
@onready var visual_shadow: = $VisualShadow
@onready var pre_visual_shadow: = $PreVisualShadow
@onready var shadow: = $Shadow
@onready var tween: = $Tween
@onready var cross_sound: = $ExplodeSound2


func _ready():
	spawn_sound.play_detached()

	blink_sprite.modulate.a = 0
	pre_visual.scale = Vector2.ONE * 0
	start()

	tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2.ONE, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func start():
	tick_timer.wait_time = explosion_time / tick_count
	tick_timer.start()

	timer.wait_time = explosion_time
	timer.start()









func _physics_process(delta):
	area_rotation += deg_to_rad(laser_rotation_speed) * delta
	explosion_area.global_rotation = area_rotation
	visuals.global_rotation = area_rotation
	$PreVisual.global_rotation = area_rotation
	pre_visual_shadow.global_rotation = area_rotation
	visual_shadow.global_rotation = area_rotation
	shadow.global_rotation = area_rotation
	pre_visual_shadow.global_position = global_position + Vector2(2, 2)
	visual_shadow.global_position = global_position + Vector2(2, 2)
	shadow.global_position = global_position + Vector2(2, 2)

	_shake_amount = lerp(0, _shake_amount, pow(2, - 10 * delta))
	_noise_sample += delta * noise_rate

	if not dying:


		if not dying:
			if not exploding:
				blink_sprite.modulate.a = clamp(blink_sprite.modulate.a - delta * 4, 0, 1)
				base_scale = lerp(Vector2.ONE * 0.65, base_scale, pow(2, - 25 * delta))
			else:
				for i in visuals.get_child_count():
					visuals.get_children()[i].width = 6 + _noise.get_noise_2d(i * 50, _noise_sample) * 6

		value += delta
		rotation_degrees += rotation_speed * delta

		sprite.scale.x = base_scale.x + sin(value) * 0.2 / 2
		sprite.scale.y = base_scale.y + sin(value) * 0.2 / 2
		blink_sprite.scale.x = base_scale.x + sin(value) * 0.2 / 2
		blink_sprite.scale.y = base_scale.y + sin(value) * 0.2 / 2
		if exploding:
			blink_sprite.scale += Vector2.ONE * _noise.get_noise_1d(_noise_sample * 25) * 0.5

		pre_visual.scale = Vector2.ONE * ((sqrt(blink_sprite.modulate.a) / 2) + 0.5)
		shadow.scale = sprite.scale


func explode():
	Game.camera.shake(3)
	visuals.show()
	visual_shadow.show()
	$PreVisual.hide()
	pre_visual_shadow.hide()
	_shake_amount = 1
	explode_sound.play_detached()
	cross_sound.play_detached()
	collision_shape.set_deferred("disabled", false)
	collision_shape_2.set_deferred("disabled", false)
	exploding = true
	blink_sprite.modulate.a = 1.0
	await get_tree().create_timer(explosion_duration, false).timeout

	

	dying = true
	for line in visuals.get_children():
		tween.interpolate_property(line, "width", 9, 0, 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN)
	for line in visual_shadow.get_children():
		tween.interpolate_property(line, "width", 9, 0, 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.interpolate_property(blink_sprite, "scale", Vector2.ONE * 1.25, Vector2.ZERO, 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()

	await tween.tween_all_completed

	
	
	
	
	
	
	
	

	
	
	
	
	
	
	

	
	
	
	
	
	
	

	
	
	
	
	
	
	

	queue_free()



func _on_Timer_timeout():
	explode()

func _on_TickTimer_timeout():
	tick_sound.play_detached()
	blink_sprite.modulate.a = 1.0
