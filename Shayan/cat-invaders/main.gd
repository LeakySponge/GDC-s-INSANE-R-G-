extends Node2D

signal game_start
signal game_end
signal game_reset

@export var enemy_scenes: Array[PackedScene] = []
@export var grid_size: Vector2i = Vector2i(11,4)
@export var spacing : Vector2 = Vector2(43, 30)
@export var move_speed : float = 20.0
@export var move_down_distance: float = 16.0
@export var screen_padding : float = 4.0

var move_direction : int = 1
var enemies : Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enemy_scenes.size() == 0:
		push_error("No enemy scenes assigned!")
		return

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		emit_signal("game_start")

func _on_game_start() -> void:
	
	var top_left = Vector2(-124, -100)
	
	for y in range(grid_size.y):
		if y>= enemy_scenes.size():
			push_error("Dude! Not enough enemy scenes for all rows! Row ", y, " will be skipped...")
			continue

		var enemy_scene = enemy_scenes[y]
		if enemy_scene == null:
			push_error("Enemy scene for row ", y, " is null. Skibiding the row...")
			continue
		
		for x in range(grid_size.x):
			var enemy_instance = enemy_scene.instantiate()
			add_child(enemy_instance)
			enemy_instance.position = top_left + Vector2(x * spacing.x, y * spacing.y)
			enemies.append(enemy_instance)
