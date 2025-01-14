extends Node2D

signal picked_up
signal died

@export var speed := 85
@export var acceleration := 1600
@export var friction := 25
@export var gravity := 800
@export var jump_force := 200
@export var max_walk_angle := 15
@export var walk_angle_acceleration := 60
@export var walk_angle_decay := 15

var velocity: = Vector2.ZERO
var jump_velocity: = 0.0
var jumping: = false
var dead: = false

@onready var visuals: = $Visuals
@onready var sprite: = $Visuals / Sprite2D
@onready var squasher: = $Squasher
@onready var shadow_container: = $Visuals / ShadowContainer
@onready var shadow: = $Visuals / ShadowContainer / Shadow
@onready var pickup_shape: = $PickupArea / CollisionShape2D
@onready var hurtbox_shape: = $Hurtbox / CollisionShape2D
@onready var jump_sound: = $JumpSound
@onready var land_sound: = $LandSound
@onready var pickup_sound: = $PickupSound
@onready var death_sound: = $DeathSound
@onready var death_sound_2: = $DeathSound2
@onready var pre_death_sonnd: = $PreDeathSound
@onready var tween: = $Tween
@onready var death_thingy: = $ThingyContainer / DeathThingy
@onready var thingy_tween: = $ThingyTween
@onready var thingy_container: = $ThingyContainer
@onready var pre_death_sonnd_2: = $PreDeathSound2


func _ready():
	Game.player = self


func _process(delta):
	shadow.rotation = sprite.rotation
	shadow.scale = sprite.scale
	death_thingy.rotation += delta * 250

	sprite.position.y += jump_velocity * delta

	if jump_velocity >= 0:
		jump_velocity += gravity * delta * 1.35
	else:
		jump_velocity += gravity * delta

	shadow_container.scale.x = 1 / max(abs(sprite.position.y) / 10, 1)
	shadow_container.scale.y = 1 / max(abs(sprite.position.y) / 10, 1)

	if sprite.position.y > 0:
		if jumping:
			land_sound.play()
			jumping = false
			squasher.squash()
			pickup_shape.set_deferred("disabled", false)
			hurtbox_shape.set_deferred("disabled", false)
			sprite.z_index = 0
			shadow.z_index = - 5
		sprite.position.y = 0
		jump_velocity = 0

	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	
	
	


	
	if move_input.x != 0:
		sprite.rotation_degrees += walk_angle_acceleration * move_input.x * delta
		sprite.rotation_degrees = clamp(sprite.rotation_degrees, - max_walk_angle, max_walk_angle)
	else:
		sprite.rotation_degrees = lerp(0, sprite.rotation_degrees, pow(2, - walk_angle_decay * delta))

	if move_input.x != 0:
		velocity.x += move_input.x * acceleration * delta
	else:
		velocity.x = lerp(0, velocity.x, pow(2, - friction * delta))

	if move_input.y != 0:
		velocity.y += move_input.y * acceleration * delta
	else:
		velocity.y = lerp(0, velocity.y, pow(2, - friction * delta))

	
	
	
	
	

	velocity = velocity.limit_length(speed)
	position += velocity * delta

	if position.x < - 110 or position.x > 110:
		position.x = clamp(position.x, - 110, 110)
		velocity.x = 0

	if position.y < - 80 or position.y > 80:
		position.y = clamp(position.y, - 80, 80)
		velocity.y = 0

	thingy_container.global_position = sprite.global_position + Vector2(0, - 4)
	death_thingy.position = Vector2(Game.camera._noise.get_noise_2d(0, Game.camera._noise_sample * 50), Game.camera._noise.get_noise_2d(50, Game.camera._noise_sample * 50)) * Game.camera._shake_amount * 2

	


func _input(event):
	if not dead:
		if event.is_action_pressed("jump") and not jumping:
			jump()


func jump():
	jump_sound.play_detached()
	jumping = true
	jump_velocity = - jump_force
	squasher.stretch()
	pickup_shape.set_deferred("disabled", true)
	hurtbox_shape.set_deferred("disabled", true)
	sprite.z_index = 5
	shadow.z_index = 5


func die():
	if not dead:
		dead = true

		Game.camera.noise_rate *= 1.5
		Game.camera.shake(3)

		Game.freeze(2.0 / 60.0)

		sprite.hide()
		death_thingy.show()

		land_sound.play_detached()
		pre_death_sonnd.play_detached()
		pre_death_sonnd_2.play_detached()
		tween.interpolate_property(Engine, "time_scale", 1.0, 0.025, 0.01, Tween.TRANS_QUAD, Tween.EASE_OUT)
		
		tween.start()
		thingy_tween.interpolate_property(thingy_container, "scale", Vector2.ZERO, Vector2.ONE * 1.5, 0.02, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		thingy_tween.start()
		await tween.tween_all_completed
		await get_tree().create_timer(0.75 * Engine.time_scale, false).timeout
		tween.interpolate_property(Engine, "time_scale", 0.025, 1.0, 0.01, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.interpolate_property(death_thingy, "scale", Vector2.ONE * 1.5, Vector2.ZERO, 0.01, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.start()
		await tween.tween_all_completed

		Game.camera.shake(8)
		land_sound.play_detached()
		death_sound.play_detached()
		death_sound_2.play_detached()
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Game"), 0, true)
		queue_free()
		emit_signal("died")


func _on_PickupArea_area_entered(area: Area2D):
	pickup_sound.play_detached()
	area.owner.queue_free()
	emit_signal("picked_up")


func _on_Hurtbox_area_entered(area: Area2D):
	die()
