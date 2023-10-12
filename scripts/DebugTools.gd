@tool
extends Node

@export var enable_all_on_play: bool = true

@export var enable_chaos: bool = true : set = set_enable_chaos
@export var enable_environment: bool = true : set = set_enable_environment

@export_subgroup("References")
@export var materials: Array[ShaderMaterial]
@export var environment: Environment
@export var world_env: WorldEnvironment


func _ready() -> void:
	if not Engine.is_editor_hint() and enable_all_on_play:
		set_enable_chaos(true)
		set_enable_environment(true)

func set_enable_chaos(value: bool):
	enable_chaos = value
	for mat in materials:
		mat.set_shader_parameter("chaos_amount", 10.0 if enable_chaos else 0.0)

func set_enable_environment(value: bool):
	enable_environment = value
	if world_env and enable_environment:
		world_env.environment = environment
	elif world_env:
		world_env.environment = null
