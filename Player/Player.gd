extends KinematicBody2D

# Basic Movement Variables and Constants
var moveSpeed: int = 370
const jump: int = -700
const gravity: int = 30
const UP: Vector2 = Vector2.UP

#Dashing Constants
const dashSpeed: int = 800
const dashLength: float = 0.25

#Velocity as a changing variable of a blank Vector2
var motion: Vector2  = Vector2.ZERO

# Wall sliding and jumping variables
var wallSlideSpeed: int = 100
var wallSlideGravity: int = 200
var isWallSliding: bool = true
var leftWallJumps = 0
var rightWallJumps = 0
var wallJump: bool = true

#Reference Nodes
onready var dash: Node2D = $Dash
onready var leftWall1 = $WallJump/LeftWalls/LeftWall1
onready var leftWall2 = $WallJump/LeftWalls/LeftWall2
onready var rightWall1 = $WallJump/RightWalls/RightWall1
onready var rightWall2 = $WallJump/RightWalls/RightWall2

func _physics_process(delta):
	#Applying Gravity
	motion.y += gravity
	
	#Dashing
	if Input.is_action_just_pressed("Dash") and dash.can_dash and !dash.is_dashing():
		dash.start_dash(dashLength)
	var speed = dashSpeed if dash.is_dashing() else moveSpeed
	
	#Basic Movement
	if Input.is_action_pressed("MoveRight"):
		motion.x = speed
	elif Input.is_action_pressed("MoveLeft"):
		motion.x = -speed
	else:
		motion.x = lerp(motion.x,0,0.2)
	
	# Wall Slide
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("MoveLeft") or Input.is_action_pressed("MoveRight") or abs(Input.get_joy_axis(0,0 > 0.3)):
			isWallSliding = true
		else:
			isWallSliding = false
	else:
		isWallSliding = false
	
	if isWallSliding == true:
		motion.y += wallSlideGravity * delta
		motion.y = min(motion.y, wallSlideSpeed)
	
	# Jumping and Wall Jumping
	if Input.is_action_just_pressed("Jump"): 
		if is_on_floor():
			motion.y = jump
			leftWallJumps = 0
			rightWallJumps = 0
		if (rightWall1.is_colliding() or rightWall2.is_colliding()) and Input.is_action_pressed("MoveRight"):
			if rightWallJumps < 2:
				rightWallJumps = rightWallJumps + 1
				
				if wallJump == true:
					if rightWallJumps == 1:
						motion.y = jump
						print(motion.y)
						print(rightWallJumps, ": right jump")
					elif rightWallJumps == 2:
						motion.y = jump
						print(motion.y)
						print(rightWallJumps, ": right jump")
					else:
						pass
		if (rightWall1.is_colliding() and rightWall2.is_colliding()) and isWallSliding == true and Input.is_action_pressed("MoveLeft") or Input.is_action_just_pressed("MoveLeft"):
			leftWallJumps = 0
			motion.y = jump
		else:
			pass
		
		if (leftWall1.is_colliding() or leftWall2.is_colliding()) and Input.is_action_pressed("MoveLeft"):
			if leftWallJumps < 2:
				leftWallJumps = leftWallJumps + 1
				
				if wallJump == true:
					if leftWallJumps == 1:
						motion.y = jump
						print(motion.y)
						print(leftWallJumps, ": left jump")
					elif leftWallJumps == 2:
						motion.y = jump
						print(motion.y)
						print(leftWallJumps, ": left jump")
					else:
						pass
		if (leftWall1.is_colliding() or leftWall2.is_colliding()) and isWallSliding == true and Input.is_action_pressed("MoveRight") or Input.is_action_just_pressed("MoveRight"):
			rightWallJumps = 0
			motion.y = jump
		else:
			pass
		
	
	motion = move_and_slide(motion, UP)



