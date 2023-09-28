extends Camera3D

@export var pivot: Node3D

@export var mouse_sensitivity: = 0.005
@export var mouse_smoothing: = 0.8
@export var mouse_vertical_limit: = 89.0
@export var capture_mouse_on_start: = true

var current_rot: Vector2
var target_rot: Vector2

func _ready() -> void:
	target_rot = Vector2(rotation.x, rotation.y)
	current_rot = target_rot
	
	if capture_mouse_on_start:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _process(delta: float) -> void:
	current_rot = current_rot.lerp(target_rot, mouse_smoothing)
	
	if pivot:
		pivot.rotation.y = current_rot.y
	else:
		rotation.y = current_rot.y
	rotation.x = current_rot.x

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		target_rot.y -= event.relative.x * mouse_sensitivity
		target_rot.x -= event.relative.y * mouse_sensitivity
		target_rot.x = clampf(target_rot.x, -deg_to_rad(mouse_vertical_limit), deg_to_rad(mouse_vertical_limit))
