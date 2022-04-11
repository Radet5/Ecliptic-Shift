extends KinematicBody

onready var light = $OmniLight

#South z_basis(0, 0, 1) 0
#west z_basis(-1, 0, 0) 1
#north z_basis(0, 0, -1) 2
#east z_basis(1, 0, 0) 3
var rotation_y
var grid_position
#const GRID_SIZE = 1
const GRID_OFFSET = Vector3(0.5, 0.0, 0.5)

const WALK := 1
const RUN := 2
var speed = WALK

var frame = 0
var TOTAL_FRAME = 4
var animation = "backward"
var ANIMATION_TIMEOUT = .5
var animation_timeout_counter = 0
var moving = false

var directions = ["S", "W", "N", "E"]

func _ready():

	add_to_group("player")
	
	#Set grid position and local rotation tracking
	# to match editor location/rotation of player object
	var facing = global_transform.basis.z.normalized()
	grid_position = global_transform.origin
	#This is ugly and dumb, but no other way of comparing the vectors worked
	if int(round(facing.x)) == 0:
		if facing.z == 1:
			rotation_y = 0
		else:
			rotation_y = 2
	elif facing.x == -1:
		rotation_y = 1
	else:
		rotation_y = 3

func _physics_process(delta):
	#reset idle pose if not moving
	if moving:
		animation_timeout_counter += delta
		if animation_timeout_counter > ANIMATION_TIMEOUT:
			$AnimatedSprite3D.set_frame(0)
			frame = 0
			moving = false

	# to move the character in the grid
	if Input.is_action_just_pressed("run"):
		speed = RUN
	if Input.is_action_just_released("run"):
		speed = WALK
	if Input.is_action_just_pressed("Up"):
		move_forward()
		incrementAnimation("forward")
	if Input.is_action_just_pressed("Down"):
		move_back()
		incrementAnimation("backward")
	if Input.is_action_just_pressed("Left"):
		move_left()
		incrementAnimation("left")
	if Input.is_action_just_pressed("Right"):
		move_right()
		incrementAnimation("right")
		
	

	global_transform.origin = grid_position + GRID_OFFSET
	
	if Input.is_action_just_pressed("rotate_clockwise"):
		rotate_y(-PI/2)
		rotation_y += 1
		frame = 3
		match animation:
			"forward":
				incrementAnimation("left")
			"right":
				incrementAnimation("forward")
			"backward":
				incrementAnimation("right")
			"left":
				incrementAnimation("backward")
		
	if Input.is_action_just_pressed("rotate_counterclockwise"):
		rotate_y(PI/2)
		rotation_y -= 1
		frame = 3
		match animation:
			"forward":
				incrementAnimation("right")
			"right":
				incrementAnimation("backward")
			"backward":
				incrementAnimation("left")
			"left":
				incrementAnimation("forward")
		
func direction_facing():
	return directions[rotation_y%4]

func move_forward():
	match direction_facing():
		"N":
			move_north()
		"E":
			move_east()
		"S":
			move_south()
		"W":
			move_west()

func move_back():
	match direction_facing():
		"N":
			move_south()
		"E":
			move_west()
		"S":
			move_north()
		"W":
			move_east()

func move_right():
	match direction_facing():
		"N":
			move_east()
		"E":
			move_south()
		"S":
			move_west()
		"W":
			move_north()

func move_left():
	match direction_facing():
		"N":
			move_west()
		"E":
			move_north()
		"S":
			move_east()
		"W":
			move_south()

func move_north():
	grid_position.z += speed
func move_east():
	grid_position.x -= speed
func move_west():
	grid_position.x += speed
func move_south():
	grid_position.z -= speed

func incrementAnimation(animationName):
	moving = true
	animation_timeout_counter = 0
	if animation != animationName:
		$AnimatedSprite3D.set_animation(animationName)
		animation = animationName
	frame = frame + 1
	$AnimatedSprite3D.set_frame(frame%TOTAL_FRAME)
# some helper functions (optional):
#func world_position_to_grid_position(p_world_position):
#	return (p_world_position / GRID_SIZE).round()
#func grid_position_to_world_position(p_grid_position):
#	return p_grid_position * GRID_SIZE  
#func move_node_in_grid(p_offset):
#	grid_position += p_offset
#	global_transform.origin = grid_position_to_world_position(grid_position)
