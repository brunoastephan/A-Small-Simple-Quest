class_name Player
extends Node2D

signal health_changed(new_health)
signal died()

@export var max_health := 100
@export var job : Job = preload("res://ScriptsAndResources/Player/default_job.tres")
@onready var circular_menu: CircularMenu = $CircularMenu
@onready var pool_manager: ActionPoolManager = $CircularMenu/ActionPoolManager

var current_health : int

func _ready():
	current_health = max_health
	initialize_action_system()
	
func initialize_action_system():
	if job and job.base_action_pool:
		pool_manager.base_pool = job.base_action_pool
		circular_menu.refresh_menu()
	else:
		push_warning("No job or action pool assigned to player!")

func take_damage(amount: int):
	current_health -= amount
	current_health = max(0, current_health)
	health_changed.emit(current_health)
	
	if current_health <= 0:
		died.emit()

func get_defense_value() -> int:
	return job.defense_value if job else 0

func heal(amount: int):
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)

func get_attack_damage() -> int:
	return job.attack_damage if job else 0

func execute_action(action: Action, target: Damageable) -> bool:
	if not action:
		push_error("No action provided")
		return false
	
	# Only require target for enemy/ally actions
	if action.target_type != Action.TargetType.SELF and not target:
		push_error("Action requires target but none provided")
		return false
	
	return action.execute(self, target)
