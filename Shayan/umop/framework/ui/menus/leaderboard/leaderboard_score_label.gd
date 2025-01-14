extends HBoxContainer

@onready var player_rank: = $Rank
@onready var player_name: = $Name
@onready var player_score: = $Score



func populate(rank: int, name: String, score: int) -> void :
	player_rank.text = "#%02d" % (rank + 1)
	player_name.text = name
	player_score.text = "%d" % score
