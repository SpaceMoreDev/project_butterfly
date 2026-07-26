extends Node3D

@onready var ui_jar : JarUI = $CollectionUI

var _active = false
var active : bool:
	set(val):
		_active = val
		if val:
			ui_jar.visible = true
		else:
			ui_jar.visible = false
	get:
		return _active

var show : bool :
	set (val):
		active = val
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
	if Input.is_action_just_pressed("jar"):
		show = true
		print("sss")
	elif Input.is_action_just_released("jar"):
		show = false
		print("nnnn")
