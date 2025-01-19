class_name character extends CharacterBody3D


@onready var hsm : LimboHSM = $LimboHSM
@onready var idle_state : LimboState = $LimboHSM/idle
@onready var advance_state : LimboState = $LimboHSM/advance
@onready var intro_state : LimboState = $LimboHSM/intro
@onready var lp : LimboState = $LimboHSM/lp


@export var health = 100
@export var fwdspeed = 40
@export var bwdspeed = 30
@export var fwddashdur = 18
@export var bwddashdur = 8
@export var prejump = 4
@export var neutraljump = 50
@export var digjump = 35
@export var supneutraljump = 35
@export var supdigjump = 35
@export var playernum = 1

var fall_acceleration = 5

var canAttack : bool = false
var inAir : bool = false
var close : bool = false

var target_velocity = Vector3.ZERO




func _ready() -> void:
	SignalManager.start_intros.connect(on_start_intros)
	if playernum == 1:
		Global.player1 = self
	else:
		Global.player2 = self
	
	_init_state_machine()
	

func _init_state_machine() -> void:
	hsm.add_transition(idle_state, advance_state, &"advance_started")
	hsm.add_transition(advance_state, idle_state, &"advance_ended")
	hsm.add_transition(idle_state, intro_state, &"intro")
	hsm.add_transition(intro_state, idle_state, &"start")
	hsm.add_transition(idle_state, lp, &"lp")
	hsm.add_transition(lp, idle_state, &"lpD")
	
	hsm.initialize(self)
	hsm.set_active(true)

func _physics_process(delta):
	
	var direction = Vector3.ZERO
	
	#HACK: Currently, movement is on the base of the character. States should be responsible for this.
	if Global.game_state == "loop":
		if playernum == 1:
			if Input.is_action_pressed("right"):
				direction.x += 1
				hsm.dispatch(&"advance_started")
			if Input.is_action_pressed("left"):
				direction.x -= 1
			if Input.is_action_just_pressed("up") and is_on_floor():
				if Input.is_action_just_pressed("right"):
					target_velocity.y = digjump 
				else:
					target_velocity.y = neutraljump
			if velocity.x == 0:
				hsm.dispatch(&"advance_ended")
		
		if not is_on_floor():
			inAir = true
			target_velocity.y -= fall_acceleration
			
	
	target_velocity.x = direction.x * fwdspeed * 0.1
	velocity = target_velocity
	
	var distanceof = abs(Global.player1.global_position.x - Global.player2.global_position.x)
	
	
	
	if distanceof <= 3:
		close = true
	else:
		close = false
	
	attacks()
	
	move_and_slide()

func on_start_intros():
	#TODO: Camera Movement for Intros
	#TODO: If player 2, wait until player 1 is finished their intro.
	hsm.dispatch(&"intro")

func start_fight():
	SignalManager.start_fight.emit()
	Global.game_state = "loop"
	hsm.dispatch(&"start")

#
func attacks():
	#HACK: Attacks should be triggered not by if conditions in base. It should be through input variable in atkstates/
	if Input.is_action_just_pressed("lp") and playernum == 1:
		hsm.dispatch(&"lp")


func on_hit(velx, vely, stun):
	# VELX stands for velocity x.
	# VELY stands for velocity y.
	# When a player gets hit, the oppoent sends data to the player about the move's attributes.
	# This also triggers which animation to play.
	# TODO:
	pass
