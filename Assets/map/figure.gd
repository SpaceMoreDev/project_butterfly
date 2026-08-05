extends Node3D

@export var textures : Array[Texture2D]
@onready var audio : AudioStreamPlayer3D = $AudioStreamPlayer

var player : MovementController
var current_mat : StandardMaterial3D

var _active : bool = true
var active : bool:
	set(val):
		if current_mat:
			var tween = get_tree().create_tween()
			if val:
				tween.tween_property(current_mat, "albedo_color:a",1,2)
			else:
				tween.tween_property(current_mat, "albedo_color:a",0,2).finished.connect(_switch_texture)
		else:
			if val:
				visible = true
			else:
				visible = false
		
		_active = val
	get:
		return _active

@export var  disappearing_distance : float = 16
@export var  spawn_distance : float = 30
@export var  wait_time : float = 10

var nav : NavigationRegion3D

func _ready() -> void:
	nav = get_tree().get_first_node_in_group("navmesh") as NavigationRegion3D
	
	current_mat = $Figure.get_surface_override_material(0).duplicate_deep()
	$Figure.set_surface_override_material(0, current_mat)
	set_deferred("player", Global.Player)
	

func _switch_texture():
	audio.playing = true
	
	var limit_ct = textures.size()-1
	var rand = randi_range(0,limit_ct)
	current_mat.albedo_texture = textures[rand]
	await get_tree().create_timer(wait_time).timeout
	go_to_random_pos()
	active = true


func _check_player_distance():
	if player:
		var distance = (player.global_position - global_position).length()
		if distance < disappearing_distance:
			active = false
			
			

var random_point
func go_to_random_pos():
	var map_rid = nav.get_navigation_map()
	if player:
		var angle: float = randf_range(0.0, TAU)
		
		var distance: float = sqrt(randf()) * spawn_distance
		
		var offset: Vector3 = Vector3(cos(angle), 0, sin(angle)) * distance
		var target_position: Vector3 = player.global_position + offset
		
		random_point = NavigationServer3D.map_get_closest_point(map_rid, target_position)
		
	else:
		random_point = NavigationServer3D.map_get_random_point(map_rid, 1, false)
	
	global_position = random_point
	active = true


func _physics_process(delta: float) -> void:
	if not active:
		return
	
	call_deferred("_check_player_distance")
