extends Node3D

@export var _objective : Objective 

var _active = false
var active : bool:
	set(val):
		_active = val
	get:
		return _active

var _show : bool = false
var show : bool :
	set (val):
		_show = val
		if val:
			if _objective:
				_objective.visible = true
		else:
			if _objective:
				_objective.visible = false
		
		if Global.can_move:
			var tween = get_tree().create_tween()
			if val:
				tween.tween_property(self, "position", Vector3(-0.439,-0.46,-0.838), 0.1)
			else:
				tween.tween_property(self, "position", Vector3(-0.439,-1.321,-0.838), 0.1)
	get:
		return _show

func _ready() -> void:
	show = false
	Global.change_current_mode.connect(
		func(mode: Global.GAMEMODE):
			print(Global.GAMEMODE.keys()[mode])
			if mode == Global.GAMEMODE.BUTTERFLY_NET:
				active = true
			else:
				active = false
	)
	

func _input(event: InputEvent) -> void:
	if not active:
		return
	if not Global.can_move:
		return
	if Input.is_action_just_pressed("jar"):
		show = true
	elif Input.is_action_just_released("jar"):
		show = false
