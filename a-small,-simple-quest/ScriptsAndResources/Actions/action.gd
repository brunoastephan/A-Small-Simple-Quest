class_name Action
extends Resource

@export var display_name := "Action"
@export var cooldown_time := 0.0
var cooldown_timer := 0.0

func execute() -> bool:
	if cooldown_timer > 0:
		return false
	
	cooldown_timer = cooldown_time
	_perform_action()
	return true

func update_cooldown(delta: float) -> bool:
	if cooldown_timer > 0:
		cooldown_timer = max(0, cooldown_timer - delta)
		return cooldown_timer == 0
	return false

func _perform_action():
	print("Action executed: ", display_name)
