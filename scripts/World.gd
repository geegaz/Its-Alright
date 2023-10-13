extends Node3D

@export var respawn_pos : = Vector3.ZERO

@onready var game_ui: = $UILayer/GameUI
@onready var animation_player: = $AnimationPlayer
@onready var spawner: = $City/Home/PlayingCubeSpawner

@onready var home_door: = $City/Home/HomeDoor

var got_cube: = false
var fullscreen: = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var getting_cubes: = get_tree().get_nodes_in_group("GettingCubes")
	for cube in getting_cubes:
		cube.consumed.connect(_on_getting_cube_consumed)
	
	show_start()

func _on_playing_cube_consumed() -> void:
	game_ui.show_objective("Get a new Cube")
	animation_player.play("show_door")

func _on_home_door_interacted() -> void:
	if got_cube:
		animation_player.play("close_door")
	else:
		animation_player.play("open_door")

func _on_getting_cube_consumed()->void:
	var new_cube = spawner.spawn()
	if not got_cube:
		game_ui.show_objective("Go Home")
		got_cube = true
		home_door.active = true
		home_door.interaction_label = "Close"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_fullscreen"):
		var window: Window = get_window()
		if fullscreen:
			window.mode = Window.MODE_WINDOWED
			fullscreen = false
		else:
			window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
			fullscreen = true

func show_start()->void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	game_ui.show_objective("Play with the Cube")
	game_ui.fade_in(2.0)
	await get_tree().create_timer(2.0).timeout
	get_tree().paused = false

func show_end()->void:
	get_tree().paused = true
	game_ui.show_objective("The end")
	game_ui.fade_out(2.0)
	await get_tree().create_timer(5.0).timeout
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().quit()
	

func _on_bounds_trigger_exited(node) -> void:
	var player: Node3D = node as Node3D
	player.position = respawn_pos
