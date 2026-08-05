extends Area3D

class_name ObjectiveTarget

@export var objective_id : int = 0
var is_triggered : bool = false

func _ready() -> void:
	visible = false
	if Global.current_objective_id == objective_id:
		visible = true
	
	Global.progressed_objective.connect(
		func(obj_indx):
		if obj_indx == objective_id:
			if not is_triggered:
				visible = true
		else:
			visible = false
	)
	
	body_entered.connect(
		func(body)->void:
		if is_triggered:
			return
		
		if body.is_in_group("Player"):
			if Global.current_objective_id == objective_id:
				is_triggered = true
				visible = false
				Global.updated_objective.emit(objective_id)
		)
