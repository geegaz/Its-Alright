extends Control

@onready var warning: = $Warning
@onready var action_prompt: = $ActionPrompt
@onready var action_prompt_label: = $ActionPrompt/Label
@onready var objective_label: = $ObjectiveLabel
@onready var transition: = $Transition

var warning_tween: Tween
var objective_tween: Tween
var fading_tween: Tween


func show_prompt(text: String)->void:
	action_prompt_label.text = text
	action_prompt.show()

func hide_prompt()->void:
	action_prompt.hide()

func show_warning(duration: float = 3.0)->void:
	warning.show()
	
	if warning_tween and warning_tween.is_valid():
		warning_tween.stop()
	warning_tween = create_tween()
	warning_tween.tween_interval(duration)
	warning_tween.tween_property(warning, "modulate:a", 0.0, 1.0).from(1.0)
	warning_tween.tween_callback(warning.hide)
	await warning_tween.finished

func show_objective(text: String, duration: float = 3.0)->void:
	objective_label.text = text
	objective_label.modulate.a = 0.0
	objective_label.show()
	
	if objective_tween and objective_tween.is_valid():
		objective_tween.stop()
	objective_tween = create_tween()
	objective_tween.tween_property(objective_label, "modulate:a", 1.0, 1.0).from(0.0)
	objective_tween.tween_interval(duration)
	objective_tween.tween_property(objective_label, "modulate:a", 0.0, 1.0).from(1.0)
	objective_tween.tween_callback(objective_label.hide)
	await objective_tween.finished

func show_transition()->void:
	transition.show()
	transition.color.a = 1.0

func hide_transition()->void:
	transition.hide()
	transition.color.a = 0.0

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
