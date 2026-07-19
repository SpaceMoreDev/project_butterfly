extends Node3D

@export var anim : AnimationTree
var iscatching = false
func _ready() -> void:
	anim.animation_started.connect(_anim_finished)
	pass

func _anim_finished(anim):
	if anim == "Catching":
		iscatching = false
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		iscatching = true
	pass
