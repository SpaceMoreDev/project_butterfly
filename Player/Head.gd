extends Node3D
class_name Head

@export_node_path("Camera3D") var cam_path := NodePath("Camera")
var cam: Camera3D

@export_node_path("MovementController") var controller_path := NodePath("../")
var controller: MovementController

@export var mouse_sensitivity := 2.0
@export var y_limit := 90.0
var mouse_axis := Vector2()
var rot := Vector3()
var can_look:bool:
	get:
		return Global.can_look

@export_group("HeadBob")
@export var headbob_frequency :=3.0
@export var headbob_amplitude :=0.2
@export var headbob_time :=0.0
@export var vel_length :=0.0

func _enter_tree() -> void:
	controller = get_node(controller_path)
	cam = get_node(cam_path)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg_to_rad(y_limit)
	rot = controller.rotation


# Called when there is an input event
func _input(event: InputEvent) -> void:
	if not can_look: return
	
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		camera_rotation()


# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	var joystick_axis := Input.get_vector(&"look_left", &"look_right",
			&"look_down", &"look_up")
	
	if joystick_axis != Vector2.ZERO:
		mouse_axis = joystick_axis * 1000.0 * delta
		camera_rotation()
	
	headbob_time += delta * controller.velocity.length()
	if controller.get_real_velocity().length() > 1.0:
		var h_bob = _HeadBob(headbob_time)
		cam.h_offset = lerp(cam.h_offset, h_bob.x * vel_length, 5 * delta)
		cam.v_offset = lerp(cam.v_offset, h_bob.y * vel_length, 5 * delta)
	else:
		cam.h_offset = lerp(cam.h_offset, 0.0, 5 * delta)
		cam.v_offset = lerp(cam.v_offset, 0.0, 5 * delta)

func _HeadBob(time) -> Vector2:
	var pos = Vector2.ZERO
	vel_length = min(controller.velocity.length(), 1.0)
	pos.y = sin(time * headbob_frequency) * headbob_amplitude * vel_length * float(controller.is_on_floor())
	pos.x = cos(time * headbob_frequency / 2) * headbob_amplitude * vel_length * float(controller.is_on_floor())
	return pos

func camera_rotation() -> void:
	# Horizontal mouse look.
	rot.y -= mouse_axis.x * mouse_sensitivity
	# Vertical mouse look.
	rot.x = clamp(rot.x - mouse_axis.y * mouse_sensitivity, -y_limit, y_limit)
	
	controller.rotation.y = rot.y
	rotation.x = rot.x
