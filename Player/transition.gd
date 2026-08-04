extends CanvasLayer
class_name TransitionScreen

var _active : bool = false

var active : bool :
	set(val):
		_active = val
		if val:
			visible = true
			$BlackScreen/AudioStreamPlayer2D.playing = true
		else:
			visible = false
			$BlackScreen/AudioStreamPlayer2D.playing = false
	get:
		return _active

func _ready() -> void:
	active = false
	Global.transition_screen = self
