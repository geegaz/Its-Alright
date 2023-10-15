extends Node

var fullscreen: = true

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
		
		var file_name: = "Its_Alright_%s.png"%datetime
		var dir_name: = "screenshots/"
		var base_dir: String
		if OS.has_feature("editor"):
			base_dir = "res://"
		else:
			base_dir = OS.get_executable_path().get_base_dir()
		var save_dir: = DirAccess.open(base_dir)
		if not save_dir.dir_exists(dir_name):
			save_dir.make_dir(dir_name)
		
		image.save_png(base_dir.path_join(dir_name).path_join(file_name))
