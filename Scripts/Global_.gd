extends Node

signal add_score(butterfly_text : String)
signal updated_score()
signal updated_objective(id:int)
signal shoot()

var current_objective_id : int = -1
var transition_screen : TransitionScreen
var mouse_sensitivity : float = 2.0/1000
var Player : MovementController
var PlayerDialogue : Dialogue
var butterflies_height : float = -1.5
var butterflies_speed : float = 3.0

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

var Player_net : NetHand
var Player_gun : ShotGun
var Player_book : Book

var max_count_of_butterflies : int = 0
func _ready() -> void:
	add_score.connect(
		func(bf_txt)->void:
		updated_score.emit(-999)
		)
func _use_net(active):
	if Player_net:
		Player_net.active = active

func _use_gun(active):
	if Player_gun:
		Player_gun.active = active

func start_dialogue(index):
	if PlayerDialogue:
		PlayerDialogue._scene_index = index
		PlayerDialogue._line_index = 0
		PlayerDialogue.active = true
		PlayerDialogue._next_line()

func _trigger_transition_to_scene(path_to_scene : String, wait_time : float):
	transition_screen.active = true
	await get_tree().create_timer(wait_time).timeout
	get_tree().call_deferred("change_scene_to_file",path_to_scene)
