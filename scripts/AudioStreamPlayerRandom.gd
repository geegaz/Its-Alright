extends AudioStreamPlayer

@export var streams: Array[AudioStream]
@export_range(0.0, 2.0) var min_pitch: = 1.0
@export_range(0.0, 2.0) var max_pitch: = 1.0
@export_range(-80.0, 24.0) var min_volume: = 0.0
@export_range(-80.0, 24.0) var max_volume: = 0.0

func play_random(from_position: float = 0.0) -> void:
	if streams.size() > 0:
		stream = streams.pick_random()
	pitch_scale = randf_range(min_pitch, max_pitch)
	volume_db = randf_range(min_volume, max_volume)
	
	play(from_position)
