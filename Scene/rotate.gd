extends MeshInstance3D

var rot_rate = 1

func _process(delta: float) -> void:
	rotate_y( rot_rate * delta)
	pass
