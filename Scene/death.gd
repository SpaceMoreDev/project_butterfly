extends Node3D

@export var main_menu_scene :String = "res://Scene/main_menu.tscn"

func _end_game():
	Global._trigger_transition_to_scene(main_menu_scene,0.0)
