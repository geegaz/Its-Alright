extends Control

@onready var action_prompt: = $ActionPrompt
@onready var action_prompt_label: = $ActionPrompt/Label
@onready var objective_label: = $ObjectiveLabel
@onready var transition: = $Transition

var objective_tween: Tween
var fading_tween: Tween

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

func fade_in(duration: float = 1.0)->void:
	transition.show()
	if fading_tween and fading_tween.is_valid():
		fading_tween.stop()
	fading_tween = create_tween()
	fading_tween.tween_property(transition, "color:a", 0.0, duration)
	fading_tween.tween_callback(transition.hide)

func fade_out(duration: float = 1.0)->void:
	transition.show()
	if fading_tween and fading_tween.is_valid():
		fading_tween.stop()
	fading_tween = create_tween()
	fading_tween.tween_property(transition, "color:a", 1.0, duration)
