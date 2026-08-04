extends Area3D

@export var dialogue_to_trigger_index : int = 0
var objective_id : int  = -999
var is_triggered : bool = false

func _ready() -> void:
	body_entered.connect(
		func(body)->void:
		if is_triggered:
			return
		if body.is_in_group("Player"):
			if objective_id > 0:
				if objective_id == Global.current_objective_id:
					Global.start_dialogue(dialogue_to_trigger_index)
					is_triggered = true
			else:
				Global.start_dialogue(dialogue_to_trigger_index)
				is_triggered = true
		)
