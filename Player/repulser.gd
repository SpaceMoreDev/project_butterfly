extends Area3D

var distance = 100

func _ready() -> void:
	body_entered.connect(_on_butterfly_enter)

func _on_butterfly_enter(body):
	if body is ButterFly:
		body.move_speed = body.alerted_speed
		(body.nav_agent as NavigationAgent3D).target_position = \
			distance * (body.global_position-Global.Player.global_position).normalized()
