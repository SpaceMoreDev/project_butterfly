extends Area3D

var distance = 100

func _ready() -> void:
	body_entered.connect(_on_butterfly_enter)

func _on_butterfly_enter(body):
	if body is ButterFly:
		body.move_speed = body.alerted_speed
		
		var direction = distance * (body.global_position-Global.Player.global_position).normalized()
		var nav = body.nav_agent as NavigationAgent3D
		var map_rid = nav.get_navigation_map()
		var reachable_target = NavigationServer3D.map_get_closest_point(map_rid, direction)

		(body.nav_agent as NavigationAgent3D).target_position = reachable_target
