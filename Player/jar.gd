extends Node3D

@export var _objective : Objective 

var _active = false
var active : bool:
	set(val):
		_active = val
		if val:
			if _objective:
				_objective.visible = true
		else:
			if _objective:
				_objective.visible = false
	get:
		return _active

var show : bool :
	set (val):
		active = val
		if Global.can_move:
			var tween = get_tree().create_tween()
			if val:
				tween.tween_property(self, "position", Vector3(-0.439,-0.46,-0.838), 0.1)
			else:
				tween.tween_property(self, "position", Vector3(-0.439,-1.321,-0.838), 0.1)
	get:
		return active

func _ready() -> void:
	active = false

func _process(delta: float) -> void:
	if not Global.can_move:
		return
	if Input.is_action_just_pressed("jar"):
		show = true
		print("sss")
	elif Input.is_action_just_released("jar"):
		show = false
		print("nnnn")
