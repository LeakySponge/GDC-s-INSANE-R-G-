extends Control

@onready var particle_folder: Node2D = $"Particle Folder"

func _on_particle_timer_timeout() -> void :
	var random_pos: = Vector2(
		randf_range(0, 1920), 
		randf_range(126, 1080)
	)
	match randi_range(0, 2):
		0: add_particles("res://Particles/background_particle_1.tscn", random_pos)
		1: add_particles("res://Particles/background_particle_2.tscn", random_pos)
		2: add_particles("res://Particles/background_particle_3.tscn", random_pos)

func add_particles(path: String, position: Vector2) -> CPUParticles2D:
	var particles = load(path).instantiate()
	particle_folder.add_child(particles)
	particles.global_position = position
	particles.emitting = true
	return particles
