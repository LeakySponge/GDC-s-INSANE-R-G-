extends Node2D

@export var split_count := 2
@export var rotation_speed := 120
@export var bounces := 3
@export var initial_up := 150
@export var bounce := 0.75
@export var gravity := 400

var velocity = Vector2.ZERO
var up_speed: = 0.0
var bounces_left: = 0
var follow: = false

var Grenade: = preload("res://game/Grenade.tscn")

@onready var sprite: = $Sprite2D
@onready var shadow_container: = $ShadowContainer
@onready var shadow: = $ShadowContainer / Shadow
@onready var squasher: = $Squasher
@onready var bounce_sound: = $BounceSound
@onready var explode_sound: = $ExplodeSound


func _ready():
	up_speed = - initial_up
	bounces_left = bounces


func _physics_process(delta):
	shadow.scale.x = 1 / max(abs(sprite.position.y) / 10, 1)
	shadow.scale.y = 1 / max(abs(sprite.position.y) / 10, 1)
	shadow_container.scale = sprite.scale

	up_speed += gravity * delta
	sprite.position.y += up_speed * delta
	if sprite.position.y > 0:
		if bounces_left > 0:
			bounce_sound.play_ramped()
		else:
			explode()

		bounces_left -= 1
		squasher.squash(up_speed / 150)
		sprite.position.y = 0
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

func explode():
	Game.camera.shake(2)
	explode_sound.play_detached()

	for i in split_count:
		var grenade = Grenade.instantiate()
		grenade.position = position

		if Game.player and is_instance_valid(Game.player):
			grenade.velocity = position.direction_to(Game.player.position).rotated(deg_to_rad(30 * randf_range( - 1, 1))) * randf_range(55, 90)
		else:
			grenade.velocity = Vector2.RIGHT.rotated(randf() * PI * 2) * randf_range(35, 75)

		grenade.initial_up = 175 * randf_range(0.85, 1.15)
		grenade.follow = follow
		
		Game.add_to_level(grenade)

	queue_free()
