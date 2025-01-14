extends Node2D

@export var rotation_speed := 250.0

var value: = 0.0

var OrbCircle: = preload("res://game/OrbCircle.tscn")

@onready var shadow: = $Shadow
@onready var tween: = $Tween
@onready var visuals: = $Visuals
@onready var particles: = $Particles
@onready var extra_particles: = $ExtraParticles


func _ready():
	if Game.level._score > 0:
		var circle = OrbCircle.instantiate()
		circle.position = position
		if Game.level._score < 58 and ((Game.level._score > 0 and (Game.level._score + 1) % 5 == 0) or Game.level._score == 0):
			circle.extra = true

		Game.add_to_level(circle)


	tween.interpolate_property($Visuals / Sprite2D, "scale", Vector2.ZERO, Vector2.ONE, 0.05, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()


func _physics_process(delta):
	value += delta
	visuals.rotation_degrees += rotation_speed * delta * 0.75

	if Game.level._score < 58 and ((Game.level._score > 0 and (Game.level._score + 1) % 5 == 0) or Game.level._score == 0):
		$Visuals / Blink.modulate.a = (sin(value * 24) + 1) / 2

		if extra_particles.emitting == false:
			particles.amount = 2
			extra_particles.emitting = true

	

	visuals.scale.x = 0.65 + sin(value) * 0.2 / 2
	visuals.scale.y = 0.65 + sin(value) * 0.2 / 2

	shadow.rotation = visuals.rotation
	shadow.scale = visuals.scale
	shadow.global_position = visuals.global_position + Vector2(2, 2)
