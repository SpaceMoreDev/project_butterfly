extends Node3D
class_name Book

var current_page : Texture2D
var curent_index : int = 0

var _active = false
var active : bool:
	set(val):
		_active = val
		
		if Global.PlayerDialogue:
			if Global.PlayerDialogue.active:
				return
		
		if val:
			Global._use_net(false)
			if Global.Player:
				Global.Player.velocity = Vector3.ZERO
				(Global.Player.camera.cam as Camera3D).v_offset = 0.0
			Global.can_move = false
			
			_anim.play("Idle")
			animation_complete = true
			_anim.reset_section()
			get_tree().create_tween().tween_property(self,"position", active_transform, 0.1)
		else:
			
			_anim.stop()
			get_tree().create_tween().tween_property(self,"position", inactive_transform, 0.1).finished.connect(
				func() -> void:
					Global._use_net(true)
					Global.can_move = true
			)
	get:
		return _active

@export var inactive_transform : Vector3
@export var active_transform : Vector3

@export var all_pages : Array[Texture2D]

@onready var mat_current_page : StandardMaterial3D = $Armature/Skeleton3D/Pages.get_active_material(0)
@onready var mat_next_page : StandardMaterial3D = $Armature/Skeleton3D/Pages.get_active_material(1)
@onready var _anim : AnimationPlayer = $AnimationPlayer

var forward : bool = true
var animation_complete : bool = true

func _ready() -> void:
	Global.Player_book = self
	_refresh_book()
	
	_anim.animation_finished.connect(func (anim) -> void:
		animation_complete = true
		if curent_index+1 <= all_pages.size()-1:
			current_page = all_pages[curent_index+1]

		
		if mat_next_page:
			if current_page:
				mat_next_page.albedo_texture = current_page
		)

func Flip_Page() -> void:
	if mat_current_page:
		if current_page:
			mat_current_page.albedo_texture = current_page
		

func _refresh_book():
	current_page = all_pages[curent_index]
	if mat_current_page:
		if all_pages.size()-1 > curent_index:
			mat_current_page.albedo_texture = all_pages[curent_index]
	if mat_next_page:
		if all_pages.size()-1 > curent_index+1:
			mat_next_page.albedo_texture = all_pages[curent_index+1]

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Bring_Book"):
		active = !active
	
	if not animation_complete:
		return
	
	if Input.is_action_just_pressed("flip_test"):
		if curent_index+1 > all_pages.size()-1:
			return
		
		forward = true
		animation_complete = false
		
		curent_index += 1
		current_page = all_pages[curent_index]
			
		_anim.play("PageTurn")
	
	if Input.is_action_just_pressed("flip_back"):
		if curent_index-1 < 0:
			return
		
		forward = false
		animation_complete = false
		
		current_page = all_pages[curent_index]
		
		if mat_next_page:
			if current_page:
				mat_next_page.albedo_texture = current_page
		
		curent_index -= 1
		current_page = all_pages[curent_index]
		
		_anim.play_backwards("PageTurn")
