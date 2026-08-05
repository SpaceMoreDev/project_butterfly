extends Area3D

@onready var wind : AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	body_entered.connect(
		func(body):
		if body is MovementController:
			Global.in_cave = true
			wind.playing = true
		)
		
	body_exited.connect(
		func(body):
		if body is MovementController:
			Global.in_cave = false
			wind.playing = false
	)
