extends HBoxContainer

class_name keybind
@export var action : InputEvent

@onready var key_lable : Label = $Label
@onready var button : Button = $Button
var _is_editing : bool = false

var is_editing : bool:
	set(val):
		Global.is_binding = val
		_is_editing = val
	get:
		return _is_editing

func _ready() -> void:
	key_lable.text = action.action
	#button.text = str(action.as_text())
	
	var events = InputMap.action_get_events(action.action)
	button.text = events.reduce(join, "")
	
	button.button_up.connect(
		func():
		button.text = "[Press any button]"
		await get_tree().physics_frame
		is_editing = true
	)

func _input(event: InputEvent) -> void:
	if is_editing:
		
		if event is InputEventKey or event is InputEventMouseButton:
			set_event(event)
		elif event.is_pressed():
			set_event(null)

func join(acc, event):
	if acc == "":
		acc += event.as_text().replace("- Physical", "")
	else:
		acc += ", " + event.as_text().replace("- Physical", "")
	return acc

func set_event(event):
	is_editing = false
	if event != null:
		var mappings = InputMap.action_get_events(action.action)
		if mappings.size() > 2:
			InputMap.action_erase_event(action.action, mappings[2])

		InputMap.action_add_event(action.action, event)
		
		
	button.text = InputMap.action_get_events(action.action).reduce(join, "")
