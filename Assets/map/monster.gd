extends Node3D

class_name Monster

var target : MovementController
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D

var nav : NavigationRegion3D
var move_speed = 5
var _active : bool=true
var active : bool:
	set(val):
		_active = val
	get:
		return _active

var physics_delta: float

func _ready() -> void:
	set_deferred("target", Global.Player)
	nav = get_tree().get_first_node_in_group("navmesh") as NavigationRegion3D
	nav_agent.target_position = global_position
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	get_random_pos()

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, physics_delta * move_speed)

var random_point : Vector3 = Vector3.ZERO

func get_random_pos():
	var map_rid = nav.get_navigation_map()
	if target:
		var angle: float = randf_range(0.0, TAU)
		
		var distance: float = sqrt(randf()) * 1
		
		var offset: Vector3 = Vector3(cos(angle), 0, sin(angle)) * distance
		var target_position: Vector3 = target.global_position + offset
		
		random_point = NavigationServer3D.map_get_closest_point(map_rid, target_position)
	
		(nav_agent as NavigationAgent3D).set_target_position(random_point)
		active = true


func _physics_process(delta: float) -> void:
	physics_delta = delta
	if NavigationServer3D.map_get_iteration_id(nav_agent.get_navigation_map()) == 0:
		return
	
	if nav_agent.is_navigation_finished():
		get_random_pos()
	
	var next_pos = nav_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_pos) * move_speed
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	
	var dir = global_position.direction_to(next_pos)
	var lookdir = atan2(dir.x, dir.z)
	rotation.y = lerp_angle(rotation.y, lookdir,5 * delta)
