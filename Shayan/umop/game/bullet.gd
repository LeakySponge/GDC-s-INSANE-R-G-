extends Node2D



@export var friction := 3
@export var lifetime := 1.5
@export var follow := false
@export var line_segment_count := 4
@export var explosion_duration := 0.25
@export var noise_rate := 1000.0

var velocity: = Vector2.ZERO
var speed: = 0.0
var exploding: = false
var value: = 0.0
var dying: = false

var _noise: = FastNoiseLite.new()
var _noise_sample: = 0.0
var _shake_amount: = 0.0
var _shake_offset: = Vector2.ZERO

@onready var timer: = $Timer
@onready var tween: = $Tween
@onready var collision_shape: = $ExplosionArea / CollisionShape2D
@onready var explode_sound: = $ExplodeSound
@onready var explode_sound_2: = $ExplodeSound2
@onready var explosion_line: = $ExplosionLine
@onready var explosion_polygon: = $ExplosionPolygon
@onready var blast_shadow: = $BlastShadow


func _ready():
	timer.wait_time = lifetime
	timer.start()
	rotation = atan2(velocity.y, velocity.x)
	speed = velocity.length()
	
	


func _physics_process(delta):
	if abs(position.x) > 165 or abs(position.y) > 125:
		queue_free()

	_shake_amount = lerp(0, _shake_amount, pow(2, - 10 * delta))
	_noise_sample += delta * noise_rate

	rotation = atan2(velocity.y, velocity.x)
	velocity = lerp(Vector2.ZERO, velocity, pow(2, - friction * delta))
	speed = velocity.length()

	if follow and Game.player and is_instance_valid(Game.player):
		velocity += position.direction_to(Game.player.position) * 50 * (1 - (timer.wait_time - timer.time_left))
		velocity = velocity.limit_length(speed)

	if not exploding:
		position += velocity * delta

	if exploding:
		explosion_line.clear_points()
		explosion_line.add_point(Vector2.RIGHT * (collision_shape.shape.radius + 4))
		for i in line_segment_count:
			var noise_value = 1.0 + lerp( - 0.25, 0.25, inverse_lerp( - 1, 1, _noise.get_noise_2d(i * 100, _noise_sample))) * _shake_amount
			
			explosion_line.add_point((Vector2.RIGHT * (collision_shape.shape.radius + 4) * noise_value).rotated(PI * 2 / line_segment_count * (i + 1)))
		explosion_polygon.polygon = explosion_line.points

		blast_shadow.global_rotation = 0
		blast_shadow.polygon = explosion_polygon.polygon

	blast_shadow.scale = explosion_polygon.scale


func destroy():
	exploding = true
	Game.camera.shake(1)
	_shake_amount = 1
	explode_sound.play_detached()
	explode_sound_2.play_detached()
	collision_shape.set_deferred("disabled", false)

	await get_tree().create_timer(explosion_duration, false).timeout

	collision_shape.set_deferred("disabled", true)
	dying = true
	tween.interpolate_property(explosion_polygon, "scale", Vector2.ONE * 1.25, Vector2.ZERO, 0.05, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	await tween.tween_all_completed

	queue_free()


	tween.interpolate_property($Sprite2D, "scale", Vector2(0.5, 1.5), Vector2(1.5, 0), 0.1, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	await tween.tween_all_completed
	queue_free()


func _on_Timer_timeout():
	destroy()
