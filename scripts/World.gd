extends Node3D

@export var respawn_pos : = Vector3.ZERO
@export var sound_layers: Array[AudioStreamPlayer]

@onready var game_ui: = $UILayer/GameUI
@onready var animation_player: = $AnimationPlayer
@onready var spawner: = $City/Home/PlayingCubeSpawner

@onready var home_door: = $City/Home/HomeDoor
@onready var home_noise: = $City/Home/HomeNoise

@onready var glitch_updater: = $Character/GlitchUpdaterCity

var outside: = false
var door_opened: = false
var got_cube: = false
var home_noise_tween: Tween
var ambiance_bus_tween: Tween

func _ready() -> void:
	var getting_cubes: = get_tree().get_nodes_in_group("GettingCubes")
	for cube in getting_cubes:
		cube.consumed.connect(_on_getting_cube_consumed)
	
	show_start()

func _process(delta: float) -> void:
	if outside:
		var glitch_amount: float = glitch_updater.global_position.distance_to(glitch_updater.glitch_pos) / glitch_updater.max_distance
		glitch_amount = clampf(ease(glitch_amount, 2.0), 0.0, 1.0)
		sound_layers[0].set_amount(1.0 - glitch_amount * 0.5)
		sound_layers[1].set_amount(glitch_amount)


func show_start()->void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	game_ui.show_transition()
	await game_ui.show_warning()
	game_ui.show_objective("Play with the Cube")
	game_ui.fade_in(2.0)
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false

func show_end()->void:
	game_ui.show_objective("The end")
	game_ui.fade_out(2.0)
	await get_tree().create_timer(5.0).timeout
	get_tree().quit()

func set_bus_volume(amount: float, bus_index: int):
	if bus_index >= 0:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(amount))

func set_node_volume(amount: float, node: Node):
	if node is AudioStreamPlayer or node is AudioStreamPlayer3D:
		node.volume_db = linear_to_db(amount)

func fade_all_layers(target_amount: float, duration: = 1.0)->void:
	for layer in sound_layers:
		layer.fade(target_amount, duration)

func fade_home_noise(target_amount: float, duration: = 1.0)->void:
	if home_noise_tween and home_noise_tween.is_valid():
		home_noise_tween.stop()
	home_noise_tween = create_tween()
	home_noise_tween.tween_method(set_node_volume.bind(home_noise), db_to_linear(home_noise.volume_db), target_amount, duration)

func fade_ambiance_bus(target_amount: float, duration: = 1.0)->void:
	var bus_index: int = AudioServer.get_bus_index("Ambiance")
	var bus_volume: float = AudioServer.get_bus_volume_db(bus_index)
	
	if ambiance_bus_tween and ambiance_bus_tween.is_valid():
		ambiance_bus_tween.stop()
	ambiance_bus_tween = create_tween()
	ambiance_bus_tween.tween_method(set_bus_volume.bind(bus_index), db_to_linear(bus_volume), target_amount, duration)

############ Interactions ############

func _on_playing_cube_consumed() -> void:
	game_ui.show_objective("Get a new Cube")
	animation_player.play("show_door")

func _on_home_door_interacted() -> void:
	var bus_index: int = AudioServer.get_bus_index("Ambiance")
	if got_cube:
		animation_player.play("close_door")
		AudioServer.set_bus_effect_enabled(bus_index, 1, true)
		door_opened = false
	else:
		animation_player.play("open_door")
		AudioServer.set_bus_effect_enabled(bus_index, 1, false)
		door_opened = true

func _on_getting_cube_consumed()->void:
	var new_cube = spawner.spawn()
	if not got_cube:
		game_ui.show_objective("Go Home")
		got_cube = true
		home_door.active = true
		home_door.interaction_label = "Close"


############ Triggers ############

func _on_bounds_trigger_exited(node) -> void:
	var player: Node3D = node as Node3D
	player.position = respawn_pos


func _on_home_trigger_entered(node) -> void:
	if door_opened:
		fade_home_noise(1.0)
		fade_all_layers(0.0)
	outside = false

func _on_home_trigger_exited(node) -> void:
	if door_opened:
		fade_home_noise(0.0)
	outside = true


func _on_calm_trigger_entered(node) -> void:
	fade_ambiance_bus(0.0, 3.0)

func _on_calm_trigger_exited(node) -> void:
	fade_ambiance_bus(1.0, 3.0)
