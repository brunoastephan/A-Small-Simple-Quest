class_name ActionPoolManager
extends Node

@export var base_pool : ActionPool
var runtime_pool : ActionPool

func _ready():
	runtime_pool = base_pool.duplicate(true)

# Primary function
func get_action_set() -> Array[Action]:
	return runtime_pool.generate_action_set()

# Alias for menu_root compatibility
func refresh_actions() -> Array[Action]:
	return get_action_set()

# Keep your existing editing functions unchanged
func set_action_probability(index: int, probability: float):
	runtime_pool.action_probabilities[index] = probability
	runtime_pool.normalize_probabilities()

func add_action(action: Action, probability: float):
	runtime_pool.possible_actions.append(action)
	runtime_pool.action_probabilities.append(probability)
	runtime_pool.normalize_probabilities()

func remove_action(index: int):
	runtime_pool.possible_actions.remove_at(index)
	runtime_pool.action_probabilities.remove_at(index)
