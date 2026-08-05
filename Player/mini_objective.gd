extends CanvasLayer

func _ready() -> void:
	Global.updated_objective_text.connect(
		func(text):
		$UI/Label.text = text
		$UI/AnimationPlayer.play("slide_in")
	)
	
