extends Interactable

signal consumed

@onready var cube_mesh: = $MeshInstance3D
@onready var getting_sound: = $GettingSound

func _interact(source: Interactor)->void:
	super(source)
	consume_cube()

func consume_cube()->void:
	active = false
	
	var tween:= create_tween()
	tween.set_parallel()
	tween.tween_property(cube_mesh, "scale", Vector3.ZERO, 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.set_parallel(false)
	tween.tween_callback(emit_signal.bind("consumed"))
	tween.tween_callback(queue_free)
