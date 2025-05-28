class_name ActionPoolManager
extends Node

@export var current_list : ActionList
var current_actions : Array[Action] = []  # Explicit type

func refresh_actions() -> Array[Action]:  # Explicit return type
	current_actions = current_list.generate_action_set()
	return current_actions

func get_current_actions() -> Array[Action]:  # Explicit return type
	return current_actions
