extends Node

signal changed_part
signal finished

const PUNCTUATION_EXPR: = "[\\.!?,;]"

@export var label: Label
@export var character_duration: = 0.05
@export var pause_duration: = 0.5
@export var part_min_duration: = 0.2

var timer: SceneTreeTimer

var sequence_parts: PackedStringArray
var sequence_durations: PackedFloat32Array
var current_part: int = -1

@onready var regex: RegEx

func play(text: String)->void:
	if not label:
		printerr("No Label node was provided - skipping.")
		return
	if not regex:
		regex = RegEx.new()
		regex.compile(PUNCTUATION_EXPR)
	
	stop()
	if build_sequence(text) > 0:
		next()

func stop()->void:
	current_part = -1
	if label:
		label.text = ""
	if timer:
		timer.timeout.disconnect(next)
		timer = null

func next()->void:
	current_part += 1
	if current_part < sequence_parts.size():
		label.text = sequence_parts[current_part]
		timer = get_tree().create_timer(sequence_durations[current_part])
		timer.timeout.connect(next)
		changed_part.emit()
	else:
		label.text = ""
		finished.emit()

func build_sequence(text: String)->int:
	sequence_durations = []
	sequence_parts = text.strip_escapes().split(" ", false)
	
	for part in sequence_parts:
		var duration: float = max(part.length() * character_duration, part_min_duration)
		if regex.search(part):
			duration += pause_duration
		sequence_durations.append(duration)
	
	return sequence_parts.size()

