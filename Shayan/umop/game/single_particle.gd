extends Node2D

@export var bounce := 0.75
@export var gravity := 800

var velocity = Vector2.ZERO
var up_speed: = 0.0
var going_away: = false

@onready var sprite: = $Visuals / Sprite2D
@onready var shadow: = $Visuals / Shadow
@onready var squasher: = $Squasher
@onready var timer: = $Timer
@onready var tween: = $Tween


func _physics_process(delta):
	
	
	
	

	if velocity.length() < 1 and timer.is_stopped():
		timer.start()

	shadow.scale.x = 1 / max(abs(sprite.position.y) / 10, 1)
	shadow.scale.y = 1 / max(abs(sprite.position.y) / 10, 1)

	up_speed += gravity * delta
	if up_speed < 0:
		up_speed += gravity * delta * 0.5


	sprite.position.y += up_speed * delta
	if sprite.position.y > 0:
		squasher.squash(up_speed / 150)
		sprite.position.y = 0
		velocity *= randf_range(0.5, 0.75)
		up_speed = up_speed * - bounce

	position += velocity * delta

	if position.x < - 112 or position.x > 112:
		position.x = clamp(position.x, - 112, 112)
		velocity.x = 0

	if position.y < - 80 or position.y > 80:
		position.y = clamp(position.y, - 80, 80)
		velocity.y = 0


	if abs(sprite.position.y) > 3:
		sprite.z_index = 5
	else:
		sprite.z_index = 0



func _on_Timer_timeout():
	going_away = true

	tween.interpolate_property(sprite, "scale", Vector2(0.5, 1.5), Vector2(1.5, 0), 0.1 * randf_range(0.5, 1.0), Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	await tween.tween_all_completed
	queue_free()
