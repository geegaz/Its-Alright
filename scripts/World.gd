extends Node3D

@onready var game_ui: = $UILayer/GameUI
@onready var animation_player: = $AnimationPlayer
@onready var spawner: = $PlayingCubeSpawner

var got_cube: = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_ui.show_objective("Play with the Cube")
	
	var getting_cubes: = get_tree().get_nodes_in_group("GettingCubes")
	for cube in getting_cubes:
		cube.consumed.connect(_on_getting_cube_consumed)

func _on_playing_cube_consumed() -> void:
	game_ui.show_objective("Get a new Cube")
	animation_player.play("show_door")

func _on_home_door_interacted() -> void:
	animation_player.play("open_door")

func _on_getting_cube_consumed()->void:
	var new_cube = spawner.spawn()
	if not got_cube:
		game_ui.show_objective("Go Home")
		got_cube = true
	#new_cube.consumed.connect(_on_playing_cube_consumed)
