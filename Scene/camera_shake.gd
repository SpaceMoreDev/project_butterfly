extends Node3D
#@export var camera: Camera3D
#@export var randomStrength:float = 0.25
#@export var shakeFade:float = 10.0
#
#var rng = RandomNumberGenerator.new()
#
#var shake_strength: float = 0.0
#
#func _ready(): 
	#pass
#
#func apply_shake(): 
	#shake_strength = randomStrength
#
#func _process(delta: float) -> void: 
	#if Input.is_action_just_pressed("interact"):
		#apply_shake()
	#
	#if  !is_zero_approx(shake_strength):
		#
		#shake_strength = lerpf(shake_strength,0,shakeFade*delta)
		#var randomoffset =  randomOffset()
		#camera.h_offset = randomoffset.x
		#camera.v_offset = randomoffset.y
#func randomOffset()->Vector2:
	#return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
