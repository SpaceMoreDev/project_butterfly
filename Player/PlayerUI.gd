extends CanvasLayer
class_name PlayerUI

@onready var score_text = $Label

func _ready() -> void:
	Global.add_score.connect(add_score)

func add_score(score):
	Global.score+=score
	score_text.text = str(Global.score)
	pass

func set_score(score):
	score_text.text = str(score)
	pass
