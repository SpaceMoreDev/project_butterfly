extends Node3D

var active = false

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

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jar"):
		show = true
		print("sss")
	elif Input.is_action_just_released("jar"):
		show = false
		print("nnnn")
