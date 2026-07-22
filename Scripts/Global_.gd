extends Node

signal add_score(score)
signal updated_score()

var mouse_sensitivity : float = 2.0/1000

var butterflies_height : float = -1.5
var butterflies_speed : float = 3.0
var can_look = true
var score = 0

func _ready() -> void:
	add_score.connect(_score_add)

func _score_add(_score):
	score += _score
	updated_score.emit()
