extends Control

class_name Options

@onready var sens_label : Label = $VBoxContainer/HBoxContainer/sensLabel
@onready var sens_slider : HSlider = $VBoxContainer/HBoxContainer/HSlider
@onready var fscreen_toggle : CheckBox = $VBoxContainer/HBoxContainer2/Check
@onready var close_btn : Button = $Button

@export var in_main_menu : bool = false

func _ready() -> void:
	sens_slider.value = Global.mouse_sensitivity
	sens_label.text = "%.3f" % (Global.mouse_sensitivity * 100)

	sens_slider.value_changed.connect(func(val):
		Global.mouse_sensitivity = val
		sens_label.text = "%.3f" % (val * 100)
	)
	
	fscreen_toggle.toggled.connect(
		func(val):
		if val:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	)
	
	close_btn.button_down.connect(
		func():
		visible = false
		Global.can_move = true
		if not in_main_menu:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	)


func _input(event: InputEvent) -> void:
	if not in_main_menu:
		if Input.is_action_just_pressed("menu"):
			visible = !visible
			if visible:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				Global.can_move = false
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				Global.can_move = true
