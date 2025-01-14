extends Node2D

@export var explosion_duration := 1.0
@export var noise_rate := 1000.0
@export var rotation_speed := 120
@export var bounces := 3
@export var initial_up := 150
@export var bounce := 0.75
@export var gravity := 400
@export var line_segment_count := 4
@export var follow := false

var velocity = Vector2.ZERO
var up_speed: = 0.0
var bounces_left: = 0
var exploding: = false
var value: = 0.0
var dying: = false
var rotation_speed_new: = 0.0

var _noise: = FastNoiseLite.new()
var _noise_sample: = 0.0
var _shake_amount: = 0.0
var _shake_offset: = Vector2.ZERO

@onready var visuals: = $Visuals
@onready var sprite: = $Visuals / Sprite2D
@onready var shadow_container: = $Visuals / ShadowContainer
@onready var shadow: = $Visuals / ShadowContainer / Shadow
@onready var squasher: = $Squasher
@onready var bounce_sound: = $BounceSound
@onready var explode_sound: = $ExplodeSound
@onready var collision_shape: = $ExplosionArea / CollisionShape2D
@onready var explosion_line: = $ExplosionLine
@onready var explosion_polygon: = $ExplosionPolygon
@onready var blast_shadow: = $BlastShadow
@onready var tween: = $Tween


func _ready():
	up_speed = - initial_up
	bounces_left = bounces
	rotation_speed_new = randf_range(500, 850) * ( - 1 if (randi() % 2 == 0) else 1)


func _physics_process(delta):
	if not dying:
		
		

		if exploding:
			explosion_polygon.scale = Vector2.ONE * (1 + _noise.get_noise_1d(_noise_sample * 5) * 0.25 * max(_shake_amount, 0.25))

			_shake_amount = lerp(0, _shake_amount, pow(2, - 10 * delta))

			_noise_sample += delta * noise_rate

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
			

			
			

			pass
		else:
			shadow.scale.x = 1 / max(abs(sprite.position.y) / 10, 1)
			shadow.scale.y = 1 / max(abs(sprite.position.y) / 10, 1)
			shadow_container.scale = sprite.scale

			up_speed += gravity * delta
			sprite.position.y += up_speed * delta
			if sprite.position.y > - 4:
				if bounces_left > 0 and abs(position.x) < 110 and abs(position.y) < 80:
					bounce_sound.play_ramped()
				else:
					explode()

				
				rotation_speed_new /= 2
				bounces_left -= 1
				squasher.squash(clamp(up_speed / 150, 0, 1))
				sprite.position.y = - 4
				if follow:
					velocity *= 0.9
				else:
					velocity *= 0.75

				if follow and Game.player and is_instance_valid(Game.player):
					velocity = velocity.rotated(min(velocity.angle_to(Game.player.position - position), 45))
				up_speed = up_speed * - bounce

			position += velocity * delta

		if abs(sprite.position.y) > 3:
			sprite.z_index = 5
			shadow.z_index = 5
		else:
			sprite.z_index = 0
			shadow.z_index = 0


		blast_shadow.polygon = explosion_polygon.polygon
		blast_shadow.global_position = global_position + Vector2(2, 2)

	blast_shadow.scale = explosion_polygon.scale


func explode():
	Game.camera.shake(2)
	_shake_amount = 1
	explode_sound.play_detached()
	collision_shape.set_deferred("disabled", false)
	exploding = true
	sprite.hide()
	shadow.hide()
	await get_tree().create_timer(explosion_duration, false).timeout

	collision_shape.set_deferred("disabled", true)
	dying = true
	tween.interpolate_property(explosion_polygon, "scale", Vector2.ONE * 1.25, Vector2.ZERO, 0.05, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	await tween.tween_all_completed

	queue_free()
