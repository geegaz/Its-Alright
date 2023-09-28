extends Node3D

@export var glitch_material: ShaderMaterial
@export var glitch_speed: = 3.0
@export var max_distance: = 10.0

var glitch_pos: Vector3

func _process(delta: float) -> void:
	glitch_pos = glitch_pos.move_toward(global_position, glitch_speed * delta)
	if glitch_pos.distance_squared_to(global_position) > max_distance * max_distance:
		glitch_pos = global_position + global_position.direction_to(glitch_pos) * max_distance
	
	if glitch_material:
		glitch_material.set_shader_parameter("player_pos", glitch_pos)

