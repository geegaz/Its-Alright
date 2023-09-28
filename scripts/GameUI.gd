extends Control

@onready var action_prompt: Control = $ActionPrompt
@onready var action_prompt_label: Label = $ActionPrompt/Label
@onready var objective_label: Label = $ObjectiveLabel

var objective_tween: Tween

func show_prompt(text: String)->void:
	action_prompt_label.text = text
	action_prompt.show()

func hide_prompt()->void:
	action_prompt.hide()

func show_objective(text: String, duration: float = 3.0)->void:
	objective_label.text = text
	
	if objective_tween and objective_tween.is_valid():
		objective_tween.stop()
	objective_tween = create_tween()
	objective_tween.tween_property(objective_label, "modulate:a", 1.0, 1.0).from(0.0)
	objective_tween.tween_interval(duration)
	objective_tween.tween_property(objective_label, "modulate:a", 0.0, 1.0).from(1.0)
	objective_tween.tween_callback(hide_objective)
	
	objective_label.show()

func hide_objective()->void:
	objective_label.hide()
