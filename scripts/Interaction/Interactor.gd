class_name Interactor
extends RayCast3D

@export var game_ui: Control
@export var interact_action: String

var targeted_interactable: Interactable

func update_targeted_interactable(target: Object)->void:
	if target is Interactable and target.active:
		if game_ui:
			game_ui.show_prompt(target.interaction_label)
		else:
			printerr("No GameUI provided - can't show prompt")
		targeted_interactable = target
	else:
		if game_ui:
			game_ui.hide_prompt()
		targeted_interactable = null

func _physics_process(delta: float) -> void:
	var new_target = get_collider()
	if new_target != targeted_interactable:
		update_targeted_interactable(new_target)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(interact_action) and targeted_interactable:
		targeted_interactable._interact(self)
		update_targeted_interactable(targeted_interactable)




