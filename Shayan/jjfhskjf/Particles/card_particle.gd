extends Node2D
class_name CardParticle

@export var movement_curve: Curve
@onready var particle_spawn_timer: Timer = $"Particle Spawn Timer"

const FADE_PARTICLES = preload("res://Particles/fade_particles.tscn")
const SPEED: = 1

const SPAWN_POS = Vector2(1788, 936)
const TARGET_POS = Vector2(132, 936)

const Y_INCREASE_OVER_CURVE: = 320

const POS_FLUFF: = 20

var max_scale: = Vector2.ZERO

@onready var particle_folder: Node2D = $"Particle Folder"

func _ready() -> void :
    var scale_fluff: = randf_range(0, 0.2)
    max_scale = Vector2(1 + scale_fluff, 1 + scale_fluff)
    rotation_degrees = randi_range(-180, 180)

    global_position = SPAWN_POS
    global_position += Vector2(randf_range( - POS_FLUFF, POS_FLUFF), randf_range( - POS_FLUFF, POS_FLUFF))

    animation()

    scale = Vector2.ZERO
    pop()

    await get_tree().create_timer(randf_range(0.0, 0.1), false).timeout
    particle_spawn_timer.start()

    await get_tree().create_timer(SPEED, false).timeout
    queue_free()

func _physics_process(delta: float) -> void :
    var curve_map_val = remap(global_position.x, TARGET_POS.x, SPAWN_POS.x, 0, 1)
    global_position.y = SPAWN_POS.y - remap(movement_curve.sample(curve_map_val), 0, 1, 0, Y_INCREASE_OVER_CURVE)

func pop():
    var tween = create_tween()
    tween.tween_property(self, "scale", max_scale, 0.05)

func _on_particle_spawn_timer_timeout() -> void :
    spawn_particle()

func spawn_particle():
    var p = FADE_PARTICLES.instantiate()
    particle_folder.add_child(p)
    particle_folder.position = Vector2.ZERO

func animation():
    var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true)
    tween.tween_property(self, "global_position:x", TARGET_POS.x + randf_range( - POS_FLUFF, POS_FLUFF), SPEED)
    tween.tween_property(self, "z_index", -1, SPEED)
