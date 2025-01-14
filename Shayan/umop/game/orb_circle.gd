extends Node2D

@export  var max_size: = 32.0
@export  var duration: = 0.2
@export  var segment_count: = 32
@export  var starting_width: = 50

var circle_size: = 0.0
var extra: = false

@onready var line: = $Line2D
@onready var tween: = $Tween
@onready var decay_particles: = $DecayParticles
@onready var decay_particles_extra: = $DecayParticlesExtra
@onready var spawn_sound: = $SpawnSound


func _ready():
	decay_particles.emitting = false
	decay_particles_extra.emitting = false

	tween.interpolate_property(line, "width", starting_width, 0, duration, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.interpolate_property(self, "circle_size", 0, max_size, duration, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()

	await get_tree().create_timer(0.03, false).timeout
	spawn_sound.play_detached()

	await tween.tween_all_completed
	line.hide()

	decay_particles.emission_points = line.points
	decay_particles.amount = randf_range(2, 6)
	decay_particles.emitting = true

	if extra:
		decay_particles_extra.emission_points = line.points
		decay_particles_extra.amount = randf_range(2, 6)
		decay_particles_extra.emitting = true


	await get_tree().create_timer(2.0, false).timeout

	queue_free()


func _process(delta):
	line.clear_points()

	var step: = PI * 2 / segment_count
	for i in segment_count:
		line.add_point(Vector2.RIGHT.rotated(step * i) * circle_size)
	line.add_point(Vector2.RIGHT * circle_size)
	line.add_point(Vector2.RIGHT.rotated(step) * circle_size)
