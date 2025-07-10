class_name ActionPoolManager
extends Node

@export var base_pool : ActionPool
var runtime_pool : ActionPool

func _ready():
	if base_pool:
		runtime_pool = base_pool.duplicate(true)

func refresh_actions() -> Array[Action]:
	if runtime_pool:
		return runtime_pool.generate_action_set()
	return []
