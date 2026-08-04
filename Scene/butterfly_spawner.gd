extends Node3D

class_name Spawner

@export var butterfly_scene : PackedScene
@export var radius : float = 5.0

var timer : Timer
var time_between : float = 1
@export var max_count : int = 5

var player : CharacterBody3D
var Butterflies : Array[ButterFly]

@export var type_to_spawn : butterflies_types

func _ready():
	
	player = Global.Player
	
	var ct : int = 0
	while ct < max_count :
		var instance : ButterFly = butterfly_scene.instantiate()
		add_child(instance)
		instance.spawner = self
		if type_to_spawn:
			instance._type = type_to_spawn
		instance.setup()
		instance.active = false
		Butterflies.append(instance)
		ct+=1
	
	
	timer = Timer.new()
	add_child(timer)
	timer.autostart = true
	
	timer.start(time_between)
	timer.timeout.connect( 
		func():
		if player:
			var player_dir = -player.transform.basis.z.normalized()
			var self_to_player = (player_dir - global_position).normalized()
			var distance = (player.global_position - global_position).length()
			if distance > 10:
				var dot  = player_dir.dot(self_to_player)
				if dot > 0.7:
					spawn_randomly()
					Global.max_count_of_butterflies += 1
		)
	

func get_pooled_item() -> ButterFly:
	for i : ButterFly in Butterflies:
		if not i.active:
			return i
	return null


func spawn_randomly():
	var instance : ButterFly = get_pooled_item()
	if not instance:
		return

	var random_offset = Vector3(
		randf_range(-radius, radius),
		0.0,
		randf_range(-radius, radius)
	)

	instance.global_position = global_position + random_offset
	instance.active = true
