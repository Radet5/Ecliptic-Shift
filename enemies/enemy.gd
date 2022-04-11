extends KinematicBody
 

enum {
	PATROLL
	CHASE
	LOOK
	TELEPORT
}


var state = PATROLL

var player
var light
var lit = false
var enable_light_offset := 5
var enable_light_distance = 100

var hit_pos
var target
var position = global_transform

var current_player_pos
var previous_player_pos

onready var detect_radious = $Detect_Radious

var path = []
var path_ind = 0
var previous_target
const move_speed = 5
onready var nav = get_parent()
func _ready():
	add_to_group("units")
	player = get_parent().get_parent().get_node("Player")
	light = get_node("light")
	light.hide()
 
func _physics_process(delta):
	var player_position = player.global_transform.origin
	var distance_to_player = translation.distance_to(player_position)
	var player_foward_vector = player_position - player.get_global_transform().basis.z
	enable_light_distance = player.get_node("OmniLight").get("omni_range") + enable_light_offset
	

	
	match state:
		CHASE:
			if (previous_target != player_position):
				move_to(player_position)
				previous_target = player_position
			if !lit:
				$AudioStreamPlayer3D.play()
				light.show()
				lit = true
		LOOK:
			move_to(previous_target)
		#TELEPORT:
			
	
	if distance_to_player < enable_light_distance:
		#if (previous_target != player_position) and $RayCast.is_colliding():
			#move_to(player_position)
			#previous_target = player_position
		if !lit:
			$AudioStreamPlayer3D.play()
			light.show()
			lit = true

	elif lit && distance_to_player >= enable_light_distance:
			state = LOOK
			light.hide()
			lit = false

	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
			
			
#For testing/debuging trigger chase on mouse click
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		move_to(player.global_transform.origin)

func move_to(target_pos):
	path= nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0



func _on_Visibality_body_entered(body):
	if body.is_in_group("player"):
		state = CHASE


func _on_Visibality_body_exited(body):
	if body.is_in_group("player"):
		state = LOOK
