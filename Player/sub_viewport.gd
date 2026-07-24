extends SubViewport

var screen_size : Vector2
@export var main_cam : Node3D
@onready var sub_cam : Node3D = $SubCam

func _ready() -> void:
	screen_size = get_window().size
	size = screen_size

func _process(delta: float) -> void:
	sub_cam.global_transform = main_cam.global_transform
