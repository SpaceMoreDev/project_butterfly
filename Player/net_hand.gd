extends Node3D
class_name NetHand

# screen y = rotate around world x relative to delta movement 
# screen x = rotate around world x at 40degrees and rotate around z relative to delta movement

# vector to direction. this is the inputevent.relative so I already have that.
# i want to rotate the net based on the direction of the vector but in the game's 3D space.
# using the the right hand rule I need to rotate Y+ and Z+ to achieve this rotation forward and backward.

var move : bool = false
@onready var net_col : Area3D = $net/Area3D
@onready var net : Node3D = $net
@onready var anim_net : AnimationTree = $net/AnimationTree
var mousedelta : Vector2

var limits_xy : Vector2 = Vector2.ZERO
var default_net_pos : Transform3D
var is_catching = false
var obj_velocity : Vector3

@export var swing_threshold :float = 15.0


var forward_rotation :float = 0.0
var side_rotation :float = 0.0
var base_rotation

const FORWARD_LIMIT :float = deg_to_rad(90.0)
const SIDE_LIMIT :float = deg_to_rad(65.0)

@export var rotation_sensitivity := 0.01

func _ready() -> void:
	default_net_pos = net.transform
	base_rotation = net.rotation
	obj_velocity = net.position
	
	anim_net.animation_finished.connect(_animation_reset)
	net_col.body_entered.connect(_body_entered)
	

func _body_entered(body):
	if body is Interactable and is_catching:
		if abs(mousedelta.y) > abs(mousedelta.x):
			body.Interact()
	pass

func _animation_reset(anim):
	is_catching = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			Global.can_look = false
			move = true
		elif event.is_released() and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			forward_rotation = 0
			side_rotation = 0
			Global.can_look = true
			move = false
	if move:
		if event is InputEventMouseMotion:
			mousedelta = event.relative
			
			if abs(mousedelta.length_squared()) > 0.0:
				if abs(mousedelta.y) > abs(mousedelta.x):
					is_catching = true
				 
			
		if abs(mousedelta.y) > abs(mousedelta.x):
		
			forward_rotation += mousedelta.y * rotation_sensitivity
			forward_rotation = clamp(
				forward_rotation,
				deg_to_rad(-8.0),
				FORWARD_LIMIT
			)

		elif abs(mousedelta.x) > abs(mousedelta.y):

			side_rotation -= mousedelta.x * rotation_sensitivity
			side_rotation = clamp(
				side_rotation,
				-SIDE_LIMIT,
				SIDE_LIMIT
			)

		update_net_rotation()
			

func update_net_rotation() -> void:
	net.rotation = base_rotation + Vector3(
		forward_rotation,
		side_rotation,
		0.0
	)

func _physics_process(delta: float) -> void:
	if move:
		var mousex = mousedelta.x* delta
		var mousey = -mousedelta.y* delta
		
		obj_velocity = net.position - obj_velocity
		
		net.position.x += mousex
		net.position.y += mousey
		
		net.position.x =  clamp (net.position.x ,-1.0 ,0.8)
		net.position.y =  clamp (net.position.y, -2.0,-0.5 ) 
		
	else:
		net.transform = lerp(net.transform,default_net_pos, 5 * delta )
	
		mousedelta = Vector2.ZERO;
	pass
