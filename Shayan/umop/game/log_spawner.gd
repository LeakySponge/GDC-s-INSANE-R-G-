extends Node2D

@export var indicator_speed := 5.0
@export var max_indicator_speed := 20.0
@export var min_log_speed := 100.0
@export var max_log_speed := 150.0
@export var log_speed_step := 10.0
@export var max_log_rotation := 15.0
@export var log_rotation_step := 2.0
@export var logs_for_rotation := 15.0
@export var orbs_for_bonus := 0

@onready var log_speed: = float(min_log_speed)
@onready var log_rotation: = 0.0
@onready var indicator_value: = 0.0

@onready var spawner: = $BasicSpawner
@onready var indicator_container: = $IndicatorContainer
@onready var indicator: = $IndicatorContainer / Indicator
@onready var indicator_flash: = $IndicatorContainer / Indicator / IndicatorFlash
@onready var tween: = $Tween
@onready var indicator_sound: = $IndicatorSound

var bonus_done: = false
var spawn_direction: = 0


func _ready():
	await get_tree().create_timer(0.6, false).timeout

	spawn_direction = randi() % 4
	update_indicator()


func _process(delta):
	if $BasicSpawner / Timer.is_stopped():
		indicator_value += delta * indicator_speed
	else:
		indicator_value += delta * lerp(indicator_speed, max_indicator_speed, inverse_lerp($BasicSpawner.timer_duration, $BasicSpawner.min_duration, $BasicSpawner / Timer.wait_time))

	indicator.position = Vector2.RIGHT * sin(indicator_value) * 3

	if not bonus_done and Game.level._score > orbs_for_bonus:
		bonus_done = true
		Game.level.spawn_plus_label("+ROTATING LOG")


func first_pick():
	tween.interpolate_property(indicator, "scale", Vector2(1.25, 1.5), Vector2(0.5, 0.0), 0.12, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.interpolate_property(indicator_flash, "modulate", Color.WHITE, Color(1, 1, 1, 0), 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()


func update_indicator():
	match spawn_direction:
		0:
			indicator_container.position = Vector2( - 148, 0)
			indicator_container.rotation = 0
		1:
			indicator_container.position = Vector2(148, 0)
			indicator_container.rotation = PI
		2:
			indicator_container.position = Vector2(0, - 110)
			indicator_container.rotation = PI / 2
		3:
			indicator_container.position = Vector2(0, 110)
			indicator_container.rotation = PI / 2 * 3

	$DropShadow.show()
	$DropShadow.global_position = indicator.global_position
	indicator_container.show()
	indicator_sound.play_detached()

	tween.interpolate_property(indicator_flash, "modulate", Color.WHITE, Color(1, 1, 1, 0), 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT)

	tween.interpolate_property(indicator, "scale", Vector2.ZERO, Vector2.ONE, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
	await tween.tween_all_completed

	if not $BasicSpawner / Timer.is_stopped():
		tween.interpolate_property(indicator, "scale", Vector2.ONE, Vector2(0.5, 0.0), spawner.timer.time_left, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()


func _on_BasicSpawner_spawned(object):
	log_speed = min(min_log_speed + max(Game.level._score - 1, 0) * log_speed_step, max_log_speed)

	match spawn_direction:
		0:
			object.position.x = - 180
			object.velocity = Vector2.RIGHT * log_speed * randf_range(0.75, 1.25)
			object.rotation_degrees = 90
			object.scale.x = 25
		1:
			object.position.x = 180
			object.velocity = Vector2.LEFT * log_speed * randf_range(0.75, 1.25)
			object.rotation_degrees = 90
			object.scale.x = 25
		2:
			object.position.y = - 140
			object.velocity = Vector2.DOWN * log_speed * randf_range(0.75, 1.25)
		3:
			object.position.y = 140
			object.velocity = Vector2.UP * log_speed * randf_range(0.75, 1.25)

	if Game.level._score > orbs_for_bonus:

		log_rotation = max(min(max(Game.level._score - orbs_for_bonus, 0) * log_rotation_step, max_log_rotation), 1)
		object.rotation_speed = (3.5 + log_rotation) * ( - 1 if randi() % 2 == 0 else 1)
		
		
		

	spawn_direction = randi() % 4
	update_indicator()
	
