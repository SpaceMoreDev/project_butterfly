extends Node3D
class_name  ShotGun

@export var _active : bool = false

var shooting : bool = false

var bullets_container : HBoxContainer
@onready var _anim : AnimationTree = $AnimationTree
@onready var _shot_audio : AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var _ui_ammo : Control = $ammoUI/Ammo
@onready var _ui_ammo_label : Control = $ammoUI/no_ammo_label
@onready var _ui_ch : Control = $Crosshair/TextureRect
@onready var shotgun_anim : AnimationPlayer = $AnimationPlayer
var _camera : Camera3D
var bullets_array : Array[Control]

var active : bool :
	set(val):
		_active = val
		if val:
			visible = true
		else:
			visible = false
	get:
		return _active


var current_ammo = 0

func _fill_bullets():
	for i in bullets_container.get_children():
		bullets_array.append(i)
	current_ammo = bullets_array.size()-1
	
	_camera = Global.Player.camera.cam

func _ready() -> void:
	bullets_container = $ammoUI/Ammo
	_anim = $AnimationTree
	call_deferred("_fill_bullets")
	
	Global.change_current_mode.connect(
		func(mode: Global.GAMEMODE):
			if mode == Global.GAMEMODE.SHOTGUN:
				active = true
				Global._use_net(false)
				if _ui_ammo:
					_ui_ammo.visible = true
				if _ui_ch:
					_ui_ch.visible = true
				
			else:
				active = false
				
				if _ui_ammo:
					_ui_ammo.visible = false
				if _ui_ch:
					_ui_ch.visible = false
	)
	
	
	
	_anim.animation_started.connect(
		func(a):
		if shooting:
			shooting = false
	)
	
	Global.shoot.connect(func():
		if not active:
			return
		if _camera:
			var space_state = get_world_3d().direct_space_state
			var mousepos = get_viewport().get_mouse_position()
			
			var origin = _camera.project_ray_origin(mousepos)
			var end = origin + _camera.project_ray_normal(mousepos) * 10
			var query = PhysicsRayQueryParameters3D.create(origin, end,1<<9)
			query.collide_with_areas = true

			var result = space_state.intersect_ray(query)
			if result:
				var obj :Node3D = result.collider
					
				if obj is Monster:
					print("hit the monster")
					obj._hurt()
				else:
					print("hit something else")
					
					
		)


func _cam_shake():
	Global.shoot.emit()
	_shot_audio.playing = true
	_use_shell()


func _use_shell():
	if current_ammo < 0:
		return
	
	bullets_array[current_ammo].visible = false
	current_ammo -=1
	
	if current_ammo < 0:
		_ui_ammo_label.visible = true
		return

func _input(event: InputEvent) -> void:
	if not _active:
		return
	
	if not Global.can_move:
		return
	
	if current_ammo < 0:
		return
	
	if Input.is_action_just_pressed("Action"):
		shooting = true
		
