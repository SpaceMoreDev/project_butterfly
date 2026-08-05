extends Area3D

@onready var monster : Monster = get_parent()
func _ready() -> void:
	
	body_entered.connect(
		func(body):
		if body is MovementController:
			monster.nav_agent.target_position = body.global_position
	)
	
