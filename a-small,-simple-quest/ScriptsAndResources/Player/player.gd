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

func heal(amount: int):
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health)

func execute_action(action: Action, target):
	if action.display_name == "Attack":
		target.take_damage(job.attack_damage)
	elif action.display_name == "Defend":
		heal(job.defense_value)
