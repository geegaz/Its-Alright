extends Node3D

@export var spawned_scene: PackedScene
@export var target_parent: Node3D
@export var respawn: bool = true
@export_range(0.0, 1.0) var spawn_randomness: float = 0.2

var spawned_node: Node3D

func spawn()->Node3D:
	# Clean up previously spawned node
	if spawned_node and respawn:
		spawned_node.queue_free()
		
	# Spawn new node
	if spawned_scene:
		spawned_node = spawned_scene.instantiate()
		if target_parent:
			target_parent.add_child(spawned_node)
		else:
			get_parent().add_child(spawned_node)
		var random_offset: Vector3 = Vector3(
			randf_range(-1, 1), 
			randf_range(-1, 1), 
			randf_range(-1, 1)
		).normalized() * spawn_randomness
		spawned_node.global_transform = global_transform.translated(random_offset)
		return spawned_node
	return null
