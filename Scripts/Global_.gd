extends Node

signal add_score(butterfly_text : String)
signal updated_score()
signal updated_objective()
signal shoot()

var mouse_sensitivity : float = 2.0/1000
var Player : MovementController

var butterflies_height : float = -1.5
var butterflies_speed : float = 3.0

var can_look = true
var score = 0

var Player_net : NetHand
var Player_gun : ShotGun
var Player_book : Book

var max_count_of_butterflies : int = 0

func _use_net(active):
	if Player_net:
		Player_net.active = active

func _use_gun(active):
	if Player_gun:
		Player_gun.active = active
