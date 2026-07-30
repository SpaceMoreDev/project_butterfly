extends Interactable
class_name ButterFly

@export var _type : butterflies_types
@export var bf_visual : Dictionary[butterflies_types.BF_Type, Texture2D]

@onready var nav_agent :NavigationAgent3D = $NavigationAgent3D
@onready var anim :AnimationPlayer = $butterfly/AnimationPlayer
var height : float = -1
var move_speed : float = -1
@onready var main_bf_object : Node3D = $butterfly
@onready var mesh : MeshInstance3D = $butterfly/Butterfly/Skeleton3D/Empty_001
var random_point : Vector3
var nav : NavigationRegion3D
var target_pos : Vector3 = Vector3.ZERO
var captured:bool = false
var base_speed : float
var alerted_speed : float = false

var spawner : Spawner

var _active : bool = false

var active : bool:
	set(val):
		if val:
			main_bf_object.visible = true
			$CollisionShape3D.disabled = false
			visible = true
			captured = false
			get_random_pos()
		else:
			main_bf_object.visible = false
			$CollisionShape3D.disabled = true
			visible = false
		
		_active = val
	get:
		return _active


var unique_mat :StandardMaterial3D

func setup():
	nav = get_tree().get_first_node_in_group("navmesh") as NavigationRegion3D
	($particles as CPUParticles3D).emitting = false
	
	var rnd = RandomNumberGenerator.new()
	var random_height_offset = rnd.randf_range(-.5, .5)
	
	if _type:
		nav_agent.path_height_offset = _type.height + random_height_offset
		move_speed = _type.speed
		scale = Vector3(_type.scale,_type.scale,_type.scale)
		_change_butterfly_visual(_type.Type)
	else:
		nav_agent.path_height_offset = Global.butterflies_height + random_height_offset
		move_speed = Global.butterflies_speed
	
	base_speed = move_speed
	alerted_speed = move_speed * 1.7
	
	var offset : float = rnd.randf_range(0, anim.current_animation_length)
	anim.advance(offset)

func _change_butterfly_visual(type : butterflies_types.BF_Type):
	if bf_visual.is_empty():
		return
	
	var mat = mesh.material_override
	unique_mat = mat.duplicate()
	if bf_visual.has(type):
		unique_mat.albedo_texture = bf_visual[type]
	mesh.material_override = unique_mat


func _ready() -> void:
	setup()


func get_random_pos():
	var map_rid = nav.get_navigation_map()
	if spawner:
		var angle: float = randf_range(0.0, TAU)
		
		var distance: float = sqrt(randf()) * spawner.radius
		
		var offset: Vector3 = Vector3(cos(angle), 0, sin(angle)) * distance
		var target_position: Vector3 = spawner.global_position + offset
		
		random_point = NavigationServer3D.map_get_closest_point(map_rid, target_position)
		
	else:
		random_point = NavigationServer3D.map_get_random_point(map_rid, 1, false)
	
	move_speed = base_speed
	(nav_agent as NavigationAgent3D).target_position = random_point
	

func Interact():
	($particles as CPUParticles3D).emitting = true
	main_bf_object.visible = false
	captured = true
	Global.add_score.emit(1)
	$CollisionShape3D.disabled = true
	await get_tree().create_timer(2).timeout
	active = false

func move_vec(tar_vec, weight)-> Vector3:
	var new_vec = global_position
	var dir = global_position.direction_to(tar_vec)
	var tar = global_position+dir
	
	new_vec = new_vec.move_toward(tar, weight)
	return new_vec

func _physics_process(delta: float) -> void:
	if captured or not visible:
		return
	
	if nav_agent.is_navigation_finished():
		get_random_pos()
	
	var next_pos = nav_agent.get_next_path_position()
	global_position = move_vec(next_pos, move_speed * delta)
	
	var dir = global_position.direction_to(next_pos)
	var lookdir = atan2(-dir.x, -dir.z)
	rotation.y = lerp(rotation.y, lookdir,3 * delta)
