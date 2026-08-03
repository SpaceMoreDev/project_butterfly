extends CanvasLayer
class_name JarUI

@onready var _text = $TextureRect/Label

#func _ready() -> void:
	#Global.updated_score.connect(add_score)
#
#func add_score():
	#_text.text = "Collected "+ str(Global.score)
	#pass

func set_text(score):
	_text.text = str(score)
	pass
