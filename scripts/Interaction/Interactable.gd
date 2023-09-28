class_name Interactable
extends CollisionObject3D

signal interacted

@export var interaction_label: String = "Interact"
@export var active: bool = true

func _interact(source: Interactor)->void:
	emit_signal("interacted")
