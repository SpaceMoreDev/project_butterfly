extends Node3D
class_name ButterFly

# get random point.
# move lerp to the point.
# when in range of a landing collider the butterfly will land.
# repeat
@onready var nav_agent :NavigationAgent3D = $NavigationAgent3D
var height : float = -1
var move_speed : float = -1

var random_point : Vector3
var nav : NavigationRegion3D
var target_pos : Vector3 = Vector3.ZERO


func _ready() -> void:
	nav = get_tree().get_first_node_in_group("navmesh") as NavigationRegion3D
	
	height = Global.butterflies_height
	move_speed = Global.butterflies_speed
	
	get_random_pos()


func get_random_pos():
	random_point = NavigationServer3D.map_get_random_point(nav.get_navigation_map(), 1, false)
	(nav_agent as NavigationAgent3D).target_position = random_point
	


func move_vec(tar_vec, weight)-> Vector3:
	var new_vec = global_position
	var dir = global_position.direction_to(tar_vec)
	var tar = global_position+dir
	
	new_vec = new_vec.move_toward(tar, weight)
	return Vector3(new_vec.x,height,new_vec.z)

func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		get_random_pos()
	
	var next_pos = nav_agent.get_next_path_position()
	global_position = move_vec(next_pos, move_speed * delta)
