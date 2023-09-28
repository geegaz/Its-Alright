extends Node3D

var fullscreen: = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_fullscreen"):
		var window: Window = get_window()
		if fullscreen:
			window.mode = Window.MODE_WINDOWED
			fullscreen = false
		else:
			window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
			fullscreen = true
	
	if event.is_action_pressed("ui_screenshot"):
		var window: Window = get_window()
		var image: Image = window.get_texture().get_image()
		var datetime: String = Time.get_datetime_string_from_system().validate_filename()
		image.save_png("res://screenshots/%s.png"%datetime)
