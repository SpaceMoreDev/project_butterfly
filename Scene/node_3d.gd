extends Node3D

var _state = true
@export var current_mode : Global.GAMEMODE
@export var objectives_next_scene : String
@export var objectives_list : Array[ObjectiveData]
var state :
	set(val):
		_state = val
		if (val):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get:
		return _state

var on_pc :bool= true

func _ready():
	match OS.get_name():
		"Web":
			on_pc = false
	
	Global.change_current_mode.emit(current_mode)
	Global.change_objectives.emit(objectives_list,objectives_next_scene)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if not on_pc:
		if event is InputEventMouseButton:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#func _process(delta: float) -> void:
	#if on_pc:
		#if Input.is_action_just_pressed("free_mouse"):
			#state = !state
	#if Input.is_action_just_pressed("reload_scene"):
		#get_tree().reload_current_scene()
