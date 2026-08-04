extends Node3D
class_name  ShotGun

@export var _active : bool = false
var _anim : AnimationTree
var shooting
var bullets_container
var bullets_array : Array[Control]

var active : bool :
	set(val):
		_active = val
		if val:
			visible = true
			Global._use_net(false)
		else:
			visible = false
			Global._use_net(true)
	get:
		return _active

@onready var shotgun_anim : AnimationPlayer = $AnimationPlayer
var current_ammo = 8

func _ready() -> void:
	if not active:
		return
	_anim = $AnimationTree
	bullets_container = $ammoUI/Ammo
	if bullets_container:
		for i in bullets_container.get_children():
			bullets_array.append(i)
		
		current_ammo = bullets_array.size()-1
	_anim.animation_started.connect(
	func(anim):
		if shooting:
			shooting = false
	)
	
	active = _active

func _cam_shake():
	Global.shoot.emit()
	_use_shell()


func _use_shell():
	if current_ammo < 0:
		return
	
	bullets_array[current_ammo].visible = false
	current_ammo -=1

func _input(event: InputEvent) -> void:
	if not _active:
		return
	if not Global.can_move:
		return
	if current_ammo < 0:
		return
	if Input.is_action_just_pressed("Action"):
		shooting = true
		
