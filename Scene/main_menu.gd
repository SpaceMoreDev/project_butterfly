extends Node3D
var on_pc :bool= true
@onready var options_btm : Button = $CanvasLayer/Button2
@onready var play_btn : Button = $CanvasLayer/Button
@onready var continue_btn : Button = $CanvasLayer/Button3
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
	var level : String = ""
	var config = ConfigFile.new()
	var err = config.load("user://data.cfg")
	if err != OK:
		return
	
	for player in config.get_sections():
		level = config.get_value(player, "Level_path")
	
	if level.is_empty():
		continue_btn.visible = false
	else:
		continue_btn.visible = true
	
	continue_btn.button_down.connect(
		func():
		if level != "":
			Global._trigger_transition_to_scene(level, 0)
	)
