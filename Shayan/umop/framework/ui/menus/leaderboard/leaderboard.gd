extends CanvasLayer

signal closed

@export var LeaderboardScoreLabel: PackedScene = null

@onready var loading_label: = $MarginContainer / VBoxContainer / LoadingLabel
@onready var scores_container: = $MarginContainer / VBoxContainer / ScoresContainer
@onready var back_button: = $MarginContainer / VBoxContainer / HBoxContainer / BackButton
@onready var refresh_button: = $MarginContainer / VBoxContainer / HBoxContainer / RefreshButton



func _ready() -> void :
	back_button.connect("pressed", Callable(self, "_on_back_button_pressed"))
	refresh_button.connect("pressed", Callable(self, "_on_refresh_button_pressed"))

	load_scores()



func load_scores() -> void :
	for s in scores_container.get_children():
		s.queue_free()

	loading_label.show()
	

	
	
	
	


func add_player_score(rank: int, name: String, score: int) -> void :
	var score_label = LeaderboardScoreLabel.instantiate()
	scores_container.add_child(score_label)
	score_label.populate(rank, name, score)



func _on_back_button_pressed() -> void :
	emit_signal("closed")


func _on_refresh_button_pressed() -> void :
	load_scores()
