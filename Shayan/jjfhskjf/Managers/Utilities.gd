extends Node

func add_particles(path: String, position: Vector2) -> CPUParticles2D:
    var particles = load(path).instantiate()
    if Global.particle_folder: Global.particle_folder.add_child(particles)
    particles.global_position = position
    particles.emitting = true
    return particles
