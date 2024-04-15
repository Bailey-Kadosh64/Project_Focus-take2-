extends KinematicBody2D

# Basic Movement Variables and Constants
var move_speed: int = 350
const jump: int = -700
const gravity: int = 30
const UP: Vector2 = Vector2.UP

#Dashing Constants
const dash_speed: int = 800
const dash_length: float = 0.25

#Velocity as a changing variable of a blank Vector2
var motion: Vector2  = Vector2.ZERO

# Wall sliding and jumping variables
var wall_slide_speed: int = 100
var wall_slide_gravity: int = 200
var is_wall_sliding: bool = true
var num_of_left_wall_jumps = 0
var num_of_right_wall_jumps = 0
var wall_jump: bool = true

#Reference Nodes
onready var dash: Node2D = $Dash
onready var left_wall1 = $Wall_Jump/Left_Walls/Left_Wall
onready var left_wall2 = $Wall_Jump/Left_Walls/Left_Wall2
onready var right_wall1 = $Wall_Jump/Right_Walls/Right_Wall
onready var right_wall2 = $Wall_Jump/Right_Walls/Right_Wall2
onready var coyote_timer = $Coyote_Timer

func _physics_process(delta):
	#Applying Gravity
	motion.y += gravity
	
	#Dashing
	if Input.is_action_just_pressed("dash") and dash.can_dash and !dash.is_dashing():
		dash.start_dash(dash_length)
	var speed = dash_speed if dash.is_dashing() else move_speed
	
	#Basic Movement
	if Input.is_action_pressed("move_right"):
		motion.x = speed
	elif Input.is_action_pressed("move_left"):
		motion.x = -speed
	else:
		motion.x = lerp(motion.x,0,0.2)
	
	# Wall Slide
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or abs(Input.get_joy_axis(0,0 > 0.3)):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	
	if is_wall_sliding == true:
		motion.y += wall_slide_gravity * delta
		motion.y = min(motion.y, wall_slide_speed)
	
	# Jumping and Wall Jumping
	if Input.is_action_just_pressed("jump"): 
		if is_on_floor():
			motion.y = jump
			num_of_left_wall_jumps = 0
			num_of_right_wall_jumps = 0
		if (right_wall1.is_colliding() or right_wall2.is_colliding()) and Input.is_action_pressed("move_right"):
			if num_of_right_wall_jumps < 2:
				num_of_right_wall_jumps = num_of_right_wall_jumps + 1
				
				if wall_jump == true:
					if num_of_right_wall_jumps == 1:
						motion.y = jump
						print(motion.y)
						print(num_of_right_wall_jumps, ": right jump")
					elif num_of_right_wall_jumps == 2:
						motion.y = jump
						print(motion.y)
						print(num_of_right_wall_jumps, ": right jump")
					else:
						pass
		if (right_wall1.is_colliding() and right_wall2.is_colliding()) and is_wall_sliding == true and Input.is_action_pressed("move_left") or Input.is_action_just_pressed("move_left"):
			num_of_left_wall_jumps = 0
			motion.y = jump
		else:
			pass
		
		if (left_wall1.is_colliding() or left_wall2.is_colliding()) and Input.is_action_pressed("move_left"):
			if num_of_left_wall_jumps < 2:
				num_of_left_wall_jumps = num_of_left_wall_jumps + 1
				
				if wall_jump == true:
					if num_of_left_wall_jumps == 1:
						motion.y = jump
						print(motion.y)
						print(num_of_left_wall_jumps, ": left jump")
					elif num_of_left_wall_jumps == 2:
						motion.y = jump
						print(motion.y)
						print(num_of_left_wall_jumps, ": left jump")
					else:
						pass
		if (left_wall1.is_colliding() or left_wall2.is_colliding()) and is_wall_sliding == true and Input.is_action_pressed("move_right") or Input.is_action_just_pressed("move_right"):
			num_of_right_wall_jumps = 0
			motion.y = jump
		else:
			pass
		
	
	motion = move_and_slide(motion, UP)
