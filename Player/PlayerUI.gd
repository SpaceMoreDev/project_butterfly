extends CanvasLayer
class_name JarUI

@onready var score_text = $Label

func _ready() -> void:
	Global.updated_score.connect(add_score)

func add_score():
	score_text.text = "Collected "+ str(Global.score)
	pass

func set_score(score):
	score_text.text = str(score)
	pass
