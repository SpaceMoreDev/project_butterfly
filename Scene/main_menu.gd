extends Node3D
var on_pc :bool= true
@onready var options_btm : Button = $CanvasLayer/Button2
@onready var play_btn : Button = $CanvasLayer/Button
@onready var options_menu : Options = $Options/Menu

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	options_btm.button_down.connect(
		func():
		options_menu.visible = !options_menu.visible
	)
	
	play_btn.button_down.connect(
		func():
		Global._trigger_transition_to_scene("res://Scene/VHS_TEST.tscn",0)
	)
