extends Node2D

@export var min_bullets := 4
@export var max_bullets := 10
@export var bullet_increase_step := 1.0

@export var min_lock_duration := 0.1
@export var max_lock_duration := 0.35
@export var lock_duration_step := 0.1

@export var min_bullet_speed := 500.0
@export var max_bullet_speed := 800.0
@export var bullet_speed_step := 100.0

@export var orbs_for_bonus := 0

var current_bullets: = 0.0
var current_lock_duration: = 0.0
var current_bullet_speed: = 0.0

var bonus_done: = false


func _process(delta):
	if not bonus_done and Game.level._score > orbs_for_bonus:
		bonus_done = true
		Game.level.spawn_plus_label("+HOMING BULLETS")


func _ready():
	current_bullets = min_bullets
	current_lock_duration = max_lock_duration
	current_bullet_speed = min_bullet_speed


func _on_BasicSpawner_spawned(object):
	object.position = Utils.random_box_position(Rect2(Vector2( - 130, - 90), Vector2(260, 180)), true)
	if Game.level._score > orbs_for_bonus:

		object.follow_bullets = true
		object.sprite.modulate = Color("f77622")

	
	
	object.shot_count = min(min_bullets + max(Game.level._score - 20, 0) * bullet_increase_step, max_bullets)
	object.lock_duration = max(max_lock_duration - max(Game.level._score - 20, 0) * lock_duration_step, min_lock_duration)
	object.bullet_speed = min(min_bullet_speed + max(Game.level._score - 20, 0) * bullet_speed_step, max_bullet_speed)

	
	
	
	
	object.setup()

	current_bullets = clamp(current_bullets + bullet_increase_step, min_bullets, max_bullets)
	current_lock_duration = clamp(current_lock_duration - lock_duration_step, min_lock_duration, max_lock_duration)
	current_bullet_speed = clamp(current_bullet_speed + bullet_speed_step, min_bullet_speed, max_bullet_speed)