extends Node

enum GAMEMODE{
	BUTTERFLY_NET,
	SHOTGUN
}

signal add_score(butterfly_text : String)
signal updated_score()

signal updated_objective(id:int)
signal updated_objective_text(text:String)
signal progressed_objective(id:int)
signal shoot()

signal change_current_mode(mode : GAMEMODE)
signal change_objectives(objectives : Array[ObjectiveData], next_scene : String)

var current_mode : GAMEMODE:
	set(val):
		if Player:
			Player.current_mode = val
	get:
		if Player:
			return Player.current_mode
		return GAMEMODE.BUTTERFLY_NET

var in_cave : bool = false

var current_objectives_list : Array[ObjectiveData]

var current_objective_id : int = -1
var transition_screen : TransitionScreen

var _mouse_sensitivity : float = 0.002
var mouse_sensitivity : float :
	set(val):
		_mouse_sensitivity = val
		print(val)
	get:
		return _mouse_sensitivity
	
var Player : MovementController
var PlayerDialogue : Dialogue
var butterflies_height : float = -1.5
var butterflies_speed : float = 3.0
var jar_on = false
var can_look = true

var can_move:bool: 
	set(val):
		if Player:
			Player.canmove = val
	get:
		if Player:
			return Player.canmove
		return false

var score = 0
var _jar : JarHand
var Player_net : NetHand
var Player_gun : ShotGun
var Player_book : Book

var max_count_of_butterflies : int = 0
func _ready() -> void:
	change_objectives.connect(func(objectives, next_scene):
		current_objectives_list = objectives
		)
	change_current_mode.connect(func(mode: GAMEMODE):
		current_mode = mode
		)
	
	add_score.connect(
		func(bf_txt)->void:
		updated_score.emit(-999)
		)
func _use_net(active): #dont use
	if Player_net:
		Player_net.active = active

func _use_gun(active): #dont use
	if Player_gun:
		Player_gun.active = active

func start_dialogue(index):
	if _jar :
		if _jar.show:
			_jar.show = false
		
	
	if Player_book:
		if Player_book.active:
			Player_book.active = false
	
	if Player_net:
		Player_net.forward_rotation = 0
		Player_net.side_rotation = 0
		can_look = true
		mouse_sensitivity = Player_net.base_sensitivity
		Player_net.move = false
	
	if PlayerDialogue:
		PlayerDialogue._scene_index = index
		PlayerDialogue._line_index = 0
		PlayerDialogue.active = true
		PlayerDialogue._next_line()

func _trigger_transition_to_scene(path_to_scene : String, wait_time : float):
	if transition_screen:
		transition_screen.active = true
	await get_tree().create_timer(wait_time).timeout
	get_tree().call_deferred("change_scene_to_file",path_to_scene)
