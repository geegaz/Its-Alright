extends Interactable

signal consumed

@export var launch_force: float = 8.0
@export var cube_lives: int = 5
@export var cube_mesh: MeshInstance3D
@export var target_material: BaseMaterial3D

func _interact(source: Interactor)->void:
	super(source)
	var dir: Vector3 = (-source.global_transform.basis.z * Vector3(1.0, 0.0, 1.0) + Vector3.UP).normalized()
	call("apply_central_impulse", dir * launch_force)
	
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
	else:
		tween.tween_interval(3.0)
	tween.set_parallel(false)
	tween.tween_callback(emit_signal.bind("consumed"))
