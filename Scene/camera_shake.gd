extends Node3D
@onready var camera: Camera3D = $"../Camera"
@export var randomStrength:float = 0.25
@export var shakeFade:float = 10.0

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

func _ready(): 
	Global.updated_score.connect(score_changed)

func score_changed():
	apply_shake()

func apply_shake(): 
	shake_strength = randomStrength

func _process(delta: float) -> void: 
	if  !is_zero_approx(shake_strength):
		
		shake_strength = lerpf(shake_strength,0,shakeFade*delta)
		var randomoffset =  randomOffset()
		camera.h_offset = randomoffset.x
		camera.v_offset = randomoffset.y
func randomOffset()->Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
