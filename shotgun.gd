extends Node3D
class_name  ShotGun

@export var _active : bool = false

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

func _ready() -> void:
	active = _active

func _cam_shake():
	Global.shoot.emit()

func _input(event: InputEvent) -> void:
	if not _active:
		return
	
	if Input.is_action_just_pressed("Action"):
		if not shotgun_anim.is_playing():
			print("pew pew")
			
			shotgun_anim.play("Shoot")
