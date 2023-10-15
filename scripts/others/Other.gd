extends PathFollow3D

@export_group("Talking")
@export_enum("Sequence", "Sequence Looped", "Random") var talking_behavior: int = 0
@export_multiline var talking_text: Array[String] = []

@export_group("Walking")
@export_enum("Ignore", "Walk on Talk", "Stop on Talk") var walking_behavior: int = 0
@export var walking_speed: = 3.0 #m/s
@export var walking_stops: Array[float]

var walking: = false
var current_stop: int = -1

var current_text: int = -1
var text_indexes: Array

@onready var text_player: = $TextPlayer
@onready var text_sprite: = $Sprite3D
@onready var interaction: = $Interaction
@onready var speech_sound: = $SpeechSound

func _ready() -> void:
	text_player.stop()
	text_indexes = range(talking_text.size())
	
	interaction.active = talking_text.size() > 0
	if walking_behavior == 0 or walking_behavior == 2:
		walking = true

func _process(delta: float) -> void:
	if walking:
		progress += walking_speed * delta
	
	if walking_behavior == 1 and walking_stops.size() > 0:
		var walking_stop: float = walking_stops[current_stop]
		if progress >= walking_stop:
			progress = walking_stop
			walking = false

func _on_interaction_interacted() -> void:
	# Talking
	match talking_behavior:
		0:
			current_text = min(current_text + 1, talking_text.size() - 1)
		1:
			current_text = (current_text + 1) % talking_text.size()
		2:
			current_text = text_indexes.pop_at(randi() % text_indexes.size())
			text_indexes = range(talking_text.size())
			text_indexes.erase(current_text)
	
	text_player.play(talking_text[current_text])
	text_sprite.show()
	interaction.active = false
	
	# Walking
	if walking_behavior == 2:
		walking = false
	elif walking_behavior == 1:
		if talking_behavior == 0:
			current_stop = min(current_stop + 1, walking_stops.size() - 1)
		elif talking_behavior == 1:
			current_stop = (current_stop + 1) % walking_stops.size()
		walking = true
		


func _on_text_player_finished() -> void:
	# Talking
	text_sprite.hide()
	interaction.active = true
	
	# Walking
	if walking_behavior == 2:
		walking = true


func _on_text_player_changed_part() -> void:
	speech_sound.play_random()
