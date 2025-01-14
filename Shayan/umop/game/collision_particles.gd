extends Node2D

@export var count := 5

var SingleParticle: = preload("res://game/SingleCollisionParticle.tscn")

var color_thingy: = Color.WHITE


func _ready():
	for i in randf_range(0.75, 1) * count:
		var particle = SingleParticle.instantiate()
		particle.position = position
		particle.velocity = Vector2.RIGHT.rotated(randf() * PI * 2) * randf_range(25, 100)
		particle.up_speed = - randf_range( - 400, - 750)
		Game.add_to_level(particle)
		particle.sprite.modulate = color_thingy
