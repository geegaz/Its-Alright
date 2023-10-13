extends Area3D

enum TriggerType {
	COLLISION,
	GROUP,
	NODE
}

signal entered(node)
signal exited(node)

@export var trigger_type: TriggerType = TriggerType.COLLISION
@export var trigger_type_group: String
@export var trigger_type_node: Node
@export var trigger_on_enter: bool = true
@export var trigger_on_exit: bool = true

func is_valid_trigger(node: Node)->bool:
	match trigger_type:
		TriggerType.COLLISION:
			return true
		TriggerType.GROUP:
			if node.is_in_group(trigger_type_group):
				return true
		TriggerType.NODE:
			if node == trigger_type_node:
				return true
	return false

func _ready() -> void:
	if trigger_on_enter:
		body_entered.connect(_on_body_entered)
	if trigger_on_exit:
		body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node)->void:
	if is_valid_trigger(body):
		entered.emit(body)

func _on_body_exited(body: Node)->void:
	if is_valid_trigger(body):
		exited.emit(body)
