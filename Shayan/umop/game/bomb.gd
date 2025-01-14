extends Node2D

@export var explosion_time := 1.0
@export var tick_count := 3
@export var noise_rate := 1000.0
@export var explosion_duration := 0.25
@export var rotation_speed := 120
@export var line_segment_count := 4
@export var follow := false
@export var follow_push_speed := 135
@export var follow_friction := 9

var value: = 0.0
var exploding: = false
var base_scale: = Vector2.ONE * 1.5
var velocity: = Vector2.ZERO
var current_tick: = 0
var dying: = false

var _noise: = FastNoiseLite.new()
var _noise_sample: = 0.0
var _shake_amount: = 0.0
var _shake_offset: = Vector2.ZERO

@onready var blink_sprite: = $Blink
@onready var collision_shape: = $ExplosionArea / CollisionShape2D
@onready var timer: = $Timer
@onready var spawn_sound: = $SpawnSound
@onready var tick_sound: = $TickSound
@onready var explode_sound: = $ExplodeSound
@onready var tick_timer: = $TickTimer
@onready var explosion_line: = $ExplosionLine
@onready var explosion_polygon: = $ExplosionPolygon
@onready var blast_shadow: = $BlastShadow
@onready var sprite: = $Sprite2D
@onready var shadow: = $Shadow
@onready var tween: = $Tween


func _ready():
	spawn_sound.play_detached()

	blink_sprite.modulate.a = 0


func start():
	tick_timer.wait_time = explosion_time / tick_count
	tick_timer.start()

	timer.wait_time = explosion_time
	timer.start()








func _physics_process(delta):
	if not dying:
		explosion_polygon.scale = Vector2.ONE * (1 + _noise.get_noise_1d(_noise_sample * 5) * 0.25 * max(_shake_amount, 0.25))

		_shake_amount = lerp(0, _shake_amount, pow(2, - 10 * delta))

		_noise_sample += delta * noise_rate

		if not exploding:
			blink_sprite.modulate.a = clamp(blink_sprite.modulate.a - delta * 5, 0, 1)
			base_scale = lerp(Vector2.ONE * 0.65, base_scale, pow(2, - 25 * delta))
		else:
			explosion_line.clear_points()
			explosion_line.add_point(Vector2.RIGHT * (collision_shape.shape.radius + 4))
			for i in line_segment_count:
				var noise_value = 1.0 + lerp( - 0.25, 0.25, inverse_lerp( - 1, 1, _noise.get_noise_2d(i * 100, _noise_sample))) * _shake_amount
				
				explosion_line.add_point((Vector2.RIGHT * (collision_shape.shape.radius + 4) * noise_value).rotated(PI * 2 / line_segment_count * (i + 1)))
			explosion_polygon.polygon = explosion_line.points

		value += delta
		rotation_degrees += rotation_speed * delta
		explosion_line.global_rotation = 0
		explosion_polygon.global_rotation = 0
		blast_shadow.global_rotation = 0

		sprite.scale.x = base_scale.x + sin(value) * 0.2 / 2
		sprite.scale.y = base_scale.y + sin(value) * 0.2 / 2
		blink_sprite.scale.x = base_scale.x + sin(value) * 0.2 / 2
		blink_sprite.scale.y = base_scale.y + sin(value) * 0.2 / 2

		velocity = lerp(Vector2.ZERO, velocity, pow(2, - follow_friction * delta))
		position += velocity * delta

		shadow.scale = sprite.scale
		shadow.rotation = sprite.rotation
		shadow.global_position = sprite.global_position + Vector2(2, 2)

		blast_shadow.polygon = explosion_polygon.polygon

	blast_shadow.scale = explosion_polygon.scale


func explode():
	Game.camera.shake(2)
	_shake_amount = 1
	explode_sound.play_detached()
	collision_shape.set_deferred("disabled", false)
	exploding = true
	blink_sprite.modulate.a = 1.0
	update()
	await get_tree().create_timer(explosion_duration, false).timeout

	collision_shape.set_deferred("disabled", true)
	dying = true
	tween.interpolate_property(explosion_polygon, "scale", Vector2.ONE * 1.25, Vector2.ZERO, 0.05, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	await tween.tween_all_completed

	queue_free()


func _on_Timer_timeout():
	explode()


func _on_TickTimer_timeout():
	if current_tick < tick_count:
		tick_sound.play_detached()
		blink_sprite.modulate.a = 1.0

	current_tick += 1
	if follow and Game.player and is_instance_valid(Game.player) and current_tick < tick_count:
		velocity = position.direction_to(Game.player.position) * follow_push_speed
