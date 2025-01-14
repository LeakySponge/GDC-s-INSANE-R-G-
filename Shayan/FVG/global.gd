extends Node



var player1
var player2
var stage

var debug : Debug
var game_controller : GameController
var game_state : StringName

var characters : Dictionary = {
	"terry" : "res://combat/characters/terry/terry.tscn"
}

var stages : Dictionary = {
	"training" : "res://stages/training.tscn"
}
