extends CharacterBody3D

@export var camera: Camera3D
@export var camera_pivot: Node3D
@export var speed: = 5.0
@export var jump_height: = 1.5
@export var jump_duration: = 0.5
@export var enable_push_rigidbodies: bool = true

var gravity: float = 20.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var vertical_velocity: = velocity.y
	
	if not is_on_floor():
		vertical_velocity -= gravity * delta
	
	if camera_pivot:
		var forward: = camera_pivot.basis.z
		var right: = camera_pivot.basis.x
		velocity = (direction.x * right + direction.y * forward) * speed
	velocity.y = vertical_velocity
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_jump"):
		if is_on_floor():
			velocity.y += sqrt(2 * jump_height * gravity)
