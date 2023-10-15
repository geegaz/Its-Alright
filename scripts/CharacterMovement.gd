extends CharacterBody3D

signal started_sprinting
signal stopped_sprinting
signal jumped

@export_group("Camera")
@export var camera: Camera3D
@export var camera_pivot: Node3D

@export_group("Movement")
@export var walking_speed: = 3.0
@export var sprinting_speed: = 5.0
@export var acceleration: = 20.0
@export var deceleration: = 10.0
@export var jump_height: = 1.0
@export var jump_duration: = 0.5

var sprinting: = false
var gravity: = 20.0
var speed: = 0.0
var dir: Vector2

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:	
	var vertical_velocity: = velocity.y
	if not is_on_floor():
		vertical_velocity -= gravity * delta
	
	dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_speed: float = sprinting_speed if sprinting else walking_speed
	if dir != Vector2.ZERO:
		speed = move_toward(speed, target_speed, acceleration * delta)
	else:
		speed = move_toward(speed, 0.0, deceleration * delta)
	
	if camera_pivot:
		var forward: = camera_pivot.basis.z
		var right: = camera_pivot.basis.x
		velocity = (dir.x * right + dir.y * forward) * speed
	velocity.y = vertical_velocity
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_jump"):
		if is_on_floor():
			velocity.y += sqrt(2 * jump_height * gravity)
			jumped.emit()
	
	if event.is_action_pressed("move_sprint"):
		sprinting = true
		started_sprinting.emit()
	
	if event.is_action_released("move_sprint"):
		sprinting = false
		stopped_sprinting.emit()
	
