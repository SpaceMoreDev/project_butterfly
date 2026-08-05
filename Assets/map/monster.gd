extends Node3D

class_name Monster

enum monster_state
{
	Alive,
	Dead
}

@export var path_to_end_1 : String = "res://Scene/Death.tscn"
@export var path_to_end_2 : String = "res://Scene/BAD_END.tscn"

var target : MovementController
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@onready var hurt_particle : CPUParticles3D = $Monster/root/hurt_effect

var nav : NavigationRegion3D
var move_speed = 4
var _active : bool=true
var active : bool:
	set(val):
		_active = val
	get:
		return _active

var physics_delta: float
@onready var anim : AnimationTree = $AnimationTree

@onready var death_area : Area3D = $Area3D

func _ready() -> void:
	set_deferred("target", Global.Player)
	nav = get_tree().get_first_node_in_group("navmesh") as NavigationRegion3D
	nav_agent.target_position = global_position
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	get_random_pos()
	
	anim.animation_started.connect(
		func(anim):
		is_hurt = false
	)
	death_area.body_entered.connect(
		func(body):
		if body is MovementController:
			if active:
				_stop()
				Global._trigger_transition_to_scene(path_to_end_1, 1)
	)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, physics_delta * move_speed)

var random_point : Vector3 = Vector3.ZERO

func get_random_pos():
	if not active:
		return
	
	var map_rid = nav.get_navigation_map()
	if target:
		var angle: float = randf_range(0.0, TAU)
		
		var distance: float = sqrt(randf()) * 1
		
		var offset: Vector3 = Vector3(cos(angle), 0, sin(angle)) * distance
		var target_position: Vector3 = target.global_position + offset
		
		random_point = NavigationServer3D.map_get_closest_point(map_rid, target_position)
	
		(nav_agent as NavigationAgent3D).set_target_position(random_point)
		active = true

var is_hurt: bool = false
var health : int  = 6
var hurt_effect : float = 0.0

func _stop():
	active = false
	nav_agent.set_velocity(Vector3.ZERO)
	nav_agent.target_position = global_position

func _hurt():
	if not active:
		return
	
	is_hurt = true
	health -=1
	hurt_particle.emitting = true
	hurt_effect += 0.1
	move_speed = clamp(move_speed - 0.1, 0.1, 4)
	var clamped_val = clamp(hurt_effect,0.0,0.5)
	anim["parameters/DeathBlend/blend_amount"] = clamped_val
	
	if health < 0:
		anim["parameters/Transition/transition_request"] = str(monster_state.find_key(1))
		_stop()
		await get_tree().create_timer(10).timeout
		Global._trigger_transition_to_scene(path_to_end_2, 3)
		print("dead")

func _physics_process(delta: float) -> void:
	if not active:
		return
	
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
