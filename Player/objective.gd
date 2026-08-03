extends Node
class_name Objective

@export var objectives_list : Array[ObjectiveData]
@onready var _text = $Objective/TextureRect/Label

var objective_index : int = 0
var objective_Text : String
var objective_count : int = 0

func _ready() -> void:
	Global.updated_objective.connect(_check_objective)
	Global.add_score.connect(_check_score)
	
	var emited_text = ""
	if not objectives_list.is_empty():
		if objectives_list[0].butterfly:
			emited_text = butterflies_types.BF_Type.keys()[objectives_list[0].butterfly.Type]
	
	Global.updated_objective.emit(emited_text)

func _check_score(butterfly):
	if objective_index > objectives_list.size() - 1:
		return
	
	var objective : ObjectiveData = objectives_list[objective_index]
	if butterflies_types.BF_Type.keys()[objective.butterfly.Type] == butterfly:
		Global.score += 1
		
		if Global.score >= objective_count:
			Global.score = 0
			objective_index += 1
		_check_objective(butterfly)

func _check_objective(butterfly_text):
	if objective_index > objectives_list.size() - 1:
		return
	
	var objective : ObjectiveData = objectives_list[objective_index]
	if objective.butterfly:
		objective_Text = _update_collect_objective()
	else:
		objective_Text = str(objective.objective_text)
	
	set_text(objective_Text)
	

func _update_collect_objective():
	var objective : ObjectiveData = objectives_list[objective_index]
	objective_count = objective.collect_count
	return "Collect %s %d/%d" % [butterflies_types.BF_Type.keys()[objective.butterfly.Type], Global.score, objective_count]

func set_text(text):
	objective_Text = text
	_text.text = str(text)
	pass
