extends Node2D

@export var min_tick_timer := 1.5
@export var max_tick_timer := 3.0
@export var tick_timer_step := 0.1
@export var orbs_for_bonus := 0

@onready var tick_time: = max_tick_timer

var bonus_done: = false


func _process(delta):
	if not bonus_done and Game.level._score > orbs_for_bonus:
		bonus_done = true
		Game.level.spawn_plus_label("+HOMING BOMB")


func _on_BasicSpawner_spawned(object):
	object.position = Utils.random_box_position(Rect2(Vector2( - 105, - 75), Vector2(210, 150)))
	object.explosion_time = tick_time
	object.start()
	
	tick_time = max(max_tick_timer - max(Game.level._score - 5, 0) * tick_timer_step, min_tick_timer)

	if Game.level._score > orbs_for_bonus:
		object.follow = true
