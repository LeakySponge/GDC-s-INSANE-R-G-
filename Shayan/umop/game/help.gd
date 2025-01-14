extends CharacterBody3D
	
@export  var max_speed = 100
@export  var gravity = - 30
@export  var jump_impulse = 320
@export  var jump = false
@export  var isAttacking = false
@export  var attacking = false
	
var velocity = Vector3.ZERO
	
@onready var animatedSprite = $AnimatedSprite3D
	
func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_movement(input_vector)
	apply_gravity(delta)
	jump()
	
	if input_vector.x > 0:
		animatedSprite.animation = "walk"
		animatedSprite.flip_h = false
	elif Input.is_action_just_pressed("reverse_kick"):
		attacking = true
		jump == false
	elif attacking == true:
		animatedSprite.animation = "reverse_kick"
	elif input_vector.x < 0:
		animatedSprite.animation = "walk"
		animatedSprite.flip_h = true
	elif input_vector.z < 0:
		animatedSprite.animation = "walk"
	elif input_vector.z > 0:
		animatedSprite.animation = "walk"
	else:
		animatedSprite.animation = "idle"
	
	
	
	
	
	if not is_on_floor():
		jump = false
		animatedSprite.animation = "jumping"
	
	
	set_velocity(velocity)
	set_up_direction(Vector3.UP)
	move_and_slide()
	velocity = velocity
	
	
func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	
	return input_vector.normalized()
	
	
func apply_movement(input_vector):
	jump == false
	velocity.x = input_vector.x * max_speed
	velocity.z = input_vector.z * max_speed
	
	
func apply_gravity(delta):
	velocity.y = velocity.y + gravity
	
	
func jump():
	if is_on_floor() and Input.is_action_pressed("jump"):
		jump = true
		velocity.y = jump_impulse
	
	
func _on_AnimatedSprite3D_animation_finished():
	if animatedSprite.animation == "reverse_kick":
		isAttacking = false
