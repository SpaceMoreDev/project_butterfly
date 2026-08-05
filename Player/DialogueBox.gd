extends PanelContainer

class_name Dialogue

var _current_dialgoue : JSON
var _text_speed : float = 0.7
var _speaker : String = ""
var _line_index : int = 0

var _active : bool = false
var active : bool:
	set(val):
		_active = val
		if val:
			Global.set_deferred("can_move", false)
			dia_anim.play("fade_in")
		else:
			dia_anim.play_backwards("fade_in")
	get:
		return _active

@onready var text_ui : RichTextLabel = $RichTextLabel
@onready var indicator : Control = $indicator
@onready var dia_anim : AnimationPlayer = $AnimationPlayer

@export var _scene_index : int = 0
@export var _dia_data : DialogueData
var _parsed_data : Array

func _ready() -> void:
	Global.PlayerDialogue = self
	
	dia_anim.animation_started.connect(func (anim)->void:
		if anim == "fade_in":
			if active:
				visible = true
		)
	dia_anim.animation_finished.connect(func (anim)->void:
		if anim == "fade_in":
			if not active:
				Global.set_deferred("can_move", true)
				visible = false
		)
	
	if _dia_data:
		_current_dialgoue = _dia_data.dialogue_Json
		_parsed_data = _current_dialgoue.data
		_next_line()



func _input(event: InputEvent) -> void:
	if not active:
		return 
	
	if event.is_pressed() and not event.is_echo():
		if not _dia_data:
			active = false
			return
	if Input.is_action_just_pressed("ui_accept"):
		if indicator.visible:
			_next_line()
		else:
			return

func _next_line():
	if _scene_index >= _parsed_data.size():
		return
	
	var _parsed_dialogue = _parsed_data[_scene_index].get("dialogue")
	
	if _line_index >=_parsed_dialogue.size():
		active = false
		Global.end_dialogue()
		var nect_scene = _parsed_data[_scene_index].get("next_scene")
		if nect_scene:
			visible = false
			Global._trigger_transition_to_scene(nect_scene,1)
		return
	
	_speaker =  _parsed_dialogue[_line_index].get("speaker")
	text_ui.text = _parsed_dialogue[_line_index].get("line")

	text_ui.visible_ratio = 0.0
	
	_line_index += 1

func _process(delta: float) -> void:
	if not active:
		return 
	
	if text_ui.visible_ratio < 1:
		indicator.visible = false
		text_ui.visible_ratio += delta * _text_speed
	else:
		if indicator:
			if not indicator.visible:
				indicator.visible = true
			else:
				indicator.visible = true
