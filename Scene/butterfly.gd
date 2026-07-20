extends Interactable
class_name ButterFly

@onready var nav_agent :NavigationAgent3D = $NavigationAgent3D
@onready var anim :AnimationPlayer = $butterfly/AnimationPlayer
var height : float = -1
var move_speed : float = -1
@onready var mesh : Node3D = $butterfly
var random_point : Vector3
var nav : NavigationRegion3D
var target_pos : Vector3 = Vector3.ZERO
var captured:bool = false

func _ready() -> void:
	nav = get_tree().get_first_node_in_group("navmesh") as NavigationRegion3D
	($particles as CPUParticles3D).emitting = false
	var rnd = RandomNumberGenerator.new()
	var random_height_offset = rnd.randf_range(-1, 1)
	nav_agent.path_height_offset = Global.butterflies_height + random_height_offset
	move_speed = Global.butterflies_speed
	
	var offset : float = rnd.randf_range(0, anim.current_animation_length)
	anim.advance(offset)
	
	get_random_pos()


func get_random_pos():
	random_point = NavigationServer3D.map_get_random_point(nav.get_navigation_map(), 1, false)
	(nav_agent as NavigationAgent3D).target_position = random_point
	

func Interact():
	($particles as CPUParticles3D).emitting = true
	mesh.visible = false
	captured = true
	Global.add_score.emit(1)
	await get_tree().create_timer(2).timeout
	queue_free()

func move_vec(tar_vec, weight)-> Vector3:
	var new_vec = global_position
	var dir = global_position.direction_to(tar_vec)
	var tar = global_position+dir
	
	new_vec = new_vec.move_toward(tar, weight)
	return new_vec

func _physics_process(delta: float) -> void:
	if captured:
		return
	
	if nav_agent.is_navigation_finished():
		get_random_pos()
	
	var next_pos = nav_agent.get_next_path_position()
	global_position = move_vec(next_pos, move_speed * delta)
	
	var dir = global_position.direction_to(next_pos)
	var lookdir = atan2(-dir.x, -dir.z)
	rotation.y = lerp(rotation.y, lookdir,3 * delta)
