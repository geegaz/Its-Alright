extends Node3D

@export_enum("Sequence", "Sequence Looped", "Random") var talking_order: int = 0
@export_multiline var talking_text: Array[String] = []

var current_text: int = -1
var text_indexes: Array

@onready var text_player: = $TextPlayer
@onready var text_sprite: = $Sprite3D
@onready var interaction: = $Interaction

func _ready() -> void:
	text_player.stop()
	text_indexes = range(talking_text.size())
	
	interaction.active = talking_text.size() > 0

func _on_interaction_interacted() -> void:
	match talking_order:
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


func _on_text_player_finished() -> void:
	text_sprite.hide()
