class_name Player
extends Node2D

signal health_changed(new_health)
signal died()

@export var max_health := 100
@export var job : Job = preload("res://ScriptsAndResources/Battle/Player/default_job.tres")
@onready var circular_menu: CircularMenu = $CircularMenu
@onready var pool_manager: ActionPoolManager = $CircularMenu/ActionPoolManager
@onready var health_bar = $HealthBar/ProgressBar
@onready var health_text = $HealthBar/Label

var current_health : int
var current_defense := 0
var defense_timer : Timer

func add_defense_buff(amount: int):
	current_defense += amount
	
func _ready():
	current_health = max_health
	initialize_action_system()
	health_changed.connect(update_health_display)
	update_health_display(current_health, max_health)
	
	# Initialize timer (only once)
	defense_timer = Timer.new()
	defense_timer.one_shot = true  # Crucial - makes timer stop after one trigger
	add_child(defense_timer)
	defense_timer.timeout.connect(_on_defense_expired)

func add_timed_defense(power: int, duration: float):
	# Reset any existing defense first
	if defense_timer.time_left > 0:
		defense_timer.stop()
	
	current_defense = power
	defense_timer.start(duration)
	print("🛡️ Defense active: +", power, " for ", duration, "s")

func _on_defense_expired():
	if current_defense > 0:  # Only print if defense was actually active
		print("Defense expired")
	current_defense = 0
	
func update_health_display(new_health: int, _max_health: int):
	health_bar.value = new_health
	health_text.text = "%d/%d" % [new_health, max_health]
	
func initialize_action_system():
	if job and job.base_action_pool:
		pool_manager.base_pool = job.base_action_pool
		circular_menu.refresh_menu()
	else:
		push_warning("No job or action pool assigned to player!")

func take_damage(amount: int):
	var final_damage = max(1, amount - current_defense)
	current_health -= final_damage
	current_health = max(0, current_health)  # Prevent negative health
	health_changed.emit(current_health, max_health)
	print("Took ", final_damage, " damage (", current_defense, " blocked)")
	
	if current_health <= 0:
		died.emit()  # This will trigger battle manager
		# Disable controls
		set_process_input(false)

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
