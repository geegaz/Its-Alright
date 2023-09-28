extends Interactable

signal consumed

@export var cube_mesh: MeshInstance3D

func _interact(source: Interactor)->void:
	super(source)
	consume_cube()

func consume_cube()->void:
	active = false
	
	var tween:= create_tween()
	if cube_mesh:
		tween.set_parallel()
		tween.tween_property(cube_mesh, "position", Vector3.UP * 0.5, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).as_relative()
		tween.tween_property(cube_mesh, "scale", Vector3.ZERO, 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	else:
		tween.tween_interval(1.0)
	tween.set_parallel(false)
	tween.tween_callback(emit_signal.bind("consumed"))
	tween.tween_callback(queue_free)
