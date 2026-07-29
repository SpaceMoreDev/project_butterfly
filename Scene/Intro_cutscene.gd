extends Node3D
class_name Cutscene1

enum mouth_state
{
	Talking,
	Half,
	Silent
}

var continue_anim : bool = false

@export var Jar_moving : Node3D
@export var attached_jar : Node3D
@export var animator : AnimationTree


var is_anim_playing : bool = false
var is_moving : bool = false
var anim = "none"

func _transition_mouth(mouth_index : mouth_state):
	animator["parameters/Transition/transition_request"] = str( mouth_state.find_key( mouth_index) )

func _ready() -> void:
	attached_jar.visible = false
	
	animator.animation_started.connect(
		func (anim)->void:
		is_anim_playing = true
		continue_anim = false
		)
	animator.animation_finished.connect(
		func (anim)->void:
		is_anim_playing = false
		continue_anim = false
		)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if not is_anim_playing:
			continue_anim = true

func _is_moving_Jar():
	Jar_moving.visible = is_moving
	attached_jar.visible = !is_moving

func _Hide_Jar():
	Jar_moving.visible = true
	attached_jar.visible = false
