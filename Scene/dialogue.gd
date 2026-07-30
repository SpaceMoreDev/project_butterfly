extends PanelContainer

class_name Dialgoue

var _current_dialgoue : JSON
var _speaker : String = ""
var _line_index : int = 0
var _text_speed : float = 0.7
var _scene_index : int = 0

@export var animation_node : Cutscene1
@export var _dia_data : DialogueData
var active : bool = false

@onready var text_ui : RichTextLabel = $RichTextLabel
@onready var indicator : Control = $indicator
@onready var dia_anim : AnimationPlayer = $AnimationPlayer

var _parsed_data : Array

func _ready() -> void:
	active = false
	
	dia_anim.animation_finished.connect(func (anim)->void:
		active = true
		)
	
	_current_dialgoue = _dia_data.dialogue_Json
	_parsed_data = _current_dialgoue.data
	_next_line()

func _input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_echo():
		if animation_node:
			if not animation_node.is_anim_playing:
				_next_line()
			else:
				return

func _next_line():
	var _parsed_dialogue = _parsed_data[_scene_index].get("dialogue")
	
	if _line_index >=_parsed_dialogue.size():
		active = false
		var nect_scene = _parsed_data[_scene_index].get("next_scene")
		
		$"../../BlackScreen".visible = true
		await get_tree().create_timer(1).timeout
		
		get_tree().change_scene_to_file(nect_scene)
		return
	
	_speaker =  _parsed_dialogue[_line_index].get("speaker")
	text_ui.text = _parsed_dialogue[_line_index].get("line")
	if animation_node:
		animation_node.anim = _parsed_dialogue[_line_index].get("animation")
		animation_node._transition_mouth((_parsed_dialogue[_line_index].get("talking")).to_int())
	
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
				if animation_node:
					if not animation_node.is_anim_playing:
						indicator.visible = true
				else:
					indicator.visible = true
