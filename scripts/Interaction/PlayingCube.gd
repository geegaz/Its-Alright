extends Interactable

signal consumed

@export var launch_force: float = 8.0
@export var cube_lives: int = 5
@export var cube_mesh: MeshInstance3D
@export var target_material: BaseMaterial3D

@onready var _SoundLaunch: = $LaunchSound
@onready var _SoundBump: = $BumpSound

func _interact(source: Interactor)->void:
	super(source)
	var dir: Vector3 = (-source.global_transform.basis.z * Vector3(1.0, 0.0, 1.0) + Vector3.UP).normalized()
	call("apply_central_impulse", dir * launch_force)
	_SoundLaunch.play_random()
	
	if cube_lives > 0:
		cube_lives -= 1
	else:
		consume_cube()

func consume_cube()->void:
	active = false
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, false)
	
	var tween:= create_tween()
	if cube_mesh:
		var cube_material: BaseMaterial3D = cube_mesh.material_override
		tween.set_parallel()
		tween.tween_property(cube_material, "albedo_color", target_material.albedo_color, 3.0)
		tween.tween_property(cube_material, "roughness", target_material.roughness, 3.0)
		tween.tween_property(cube_material, "rim", 0.0, 3.0)
	else:
		tween.tween_interval(3.0)
	tween.set_parallel(false)
	tween.tween_callback(emit_signal.bind("consumed"))


func _on_body_entered(body: Node) -> void:
	var angular_vel: Vector3 = get("angular_velocity")
	var linear_vel: Vector3 = get("linear_velocity")
	var combined_speed: = angular_vel.length() + linear_vel.length()
	
	if combined_speed > 0.1:
		var target_volume: float = clamp(inverse_lerp(0.1, 20.0, combined_speed), 0.0, 1.0)
		_SoundBump.play_random()
		_SoundBump.volume_db = linear_to_db(target_volume)
