extends Area3D
class_name ammo_pickable


func _ready() -> void:
	body_entered.connect(
		func(b):
		if b is MovementController:
			if Global.add_ammo(1):
				await get_tree().process_frame
				queue_free()
	)
