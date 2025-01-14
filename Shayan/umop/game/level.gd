extends Node2D

@export var PauseMenu: PackedScene = null
@export var GameOverMenu: PackedScene = null

var _running: = true
var _score: = 0
var _hiscore_done: = false

var Orb: = preload("res://game/Orb.tscn")
var CollisionParticles: = preload("res://game/CollisionParticles.tscn")
var FloatingLabel: = preload("res://framework/node_modules/floating_label/FloatingLabel.tscn")


@onready var score_node: = $UI / ScoreNode
@onready var score_label_real: = $UI / ScoreNode / Label
@onready var player: = $Player
@onready var hiscore_sound: = $HiscoreSound
@onready var hiscore_sound_2: = $HiscoreSound2
@onready var first_time_sound: = $FirstTimeSound
@onready var first_time_sound_2: = $FirstTimeSound2
@onready var tween: = $Tween
@onready var tutorial: = $Tutorial
@onready var sound_tween: = $SoundTween



func _ready() -> void :
	Game.level = self

	spawn_orb(true)


func _input(event: InputEvent) -> void :
	if event.is_action_pressed("pause") and _running and Game.can_pause:
		var pause_menu = PauseMenu.instantiate()
		add_child(pause_menu)
		get_viewport().set_input_as_handled()
	
	
	
	


func _process(delta):
	if not $SplittingGrenades / BasicSpawner.timer.is_stopped():
		$Grenades / BasicSpawner.stop()
	if not $TripleLasers / BasicSpawner.timer.is_stopped():
		$Lasers / BasicSpawner.stop()



func _restart() -> void :
	Game.restart()


func _game_over() -> void :
	if _running:
		
		

		$Bombs / BasicSpawner.stop()
		$LogSpawner / BasicSpawner.stop()
		$Grenades / BasicSpawner.stop()
		$Lasers / BasicSpawner.stop()
		$Shooters / BasicSpawner.stop()
		$SplittingGrenades / BasicSpawner.stop()
		$TripleLasers / BasicSpawner.stop()
		$SmashBalls / BasicSpawner.stop()

		set_process_input(false)
		_running = false

		if _score > SaveManager.data.hiscore:
			SaveManager.data.hiscore = _score
			SaveManager.save_data()
		var game_over_menu = GameOverMenu.instantiate()
		add_child(game_over_menu)
		game_over_menu.update_score(_score)


func spawn_orb(first = false):
	var orb = Orb.instantiate()
	orb.position = Vector2(randf_range( - 100, 100), randf_range( - 70, 70))
	while orb.position.distance_to(player.position) < 50:
		orb.position = Vector2(randf_range( - 100, 100), randf_range( - 70, 70))
	add_child(orb)

	if first:
		orb.position = Vector2.UP * 50


func _on_Player_picked_up():

	if _score == 0:
		score_node.show()
		$Bombs / BasicSpawner.real_start()
		$LogSpawner / BasicSpawner.real_start()
		$Grenades / BasicSpawner.real_start()
		$Lasers / BasicSpawner.real_start()
		$Shooters / BasicSpawner.real_start()
		$SplittingGrenades / BasicSpawner.real_start()
		$TripleLasers / BasicSpawner.real_start()
		$SmashBalls / BasicSpawner.real_start()

		$LogSpawner.first_pick()

		tween.interpolate_property(tutorial, "modulate", Color.WHITE, Color(1, 1, 1, 0), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property($Tutorial / PressSound.random_audio_player, "volume_db", - 18, - 60, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property($Tutorial / ReleaseSound.random_audio_player, "volume_db", - 18, - 60, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()


	_score += 1

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


	
	
	score_label_real.text = "%d" % _score
	score_node.bounce()
	call_deferred("spawn_orb")

	if _score > SaveManager.data.hiscore and not _hiscore_done and SaveManager.data.hiscore > 0:
		var floating_label = FloatingLabel.instantiate()
		floating_label.position = player.position + Vector2.UP * 12
		floating_label.velocity = player.velocity / 3 * 2
		add_child(floating_label)
		floating_label.modulate = Color("fee761")
		floating_label.set_text("NEW HISCORE")

		_hiscore_done = true
		score_label_real.set("theme_override_colors/font_color", Color("fee761"))

		var particles = CollisionParticles.instantiate()
		particles.position = player.position
		particles.color_thingy = Color("fee761")
		add_child(particles)

		particles = CollisionParticles.instantiate()
		particles.count = 6
		particles.color_thingy = Color("f77622")
		particles.position = player.position
		add_child(particles)

		hiscore_sound.play_detached()
		hiscore_sound_2.play_detached()




func _on_Player_died():
	_game_over()


func spawn_plus_label(text):
	var label = FloatingLabel.instantiate()
	label.position = Game.player.position + Vector2.UP * 12
	label.velocity = Game.player.velocity / 2
	label.blink_duration = 0.07000000000000001
	label.blink_count = 8
	
	
	label.duration = 3.5
	Game.add_to_level(label)
	label.set_text(text)
	label.modulate = Color("e8b796")
	first_time_sound.play()
	first_time_sound_2.play()
