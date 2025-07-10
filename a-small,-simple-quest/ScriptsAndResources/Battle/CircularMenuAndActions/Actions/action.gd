class_name Action
extends Resource

enum TargetType {SELF, ENEMY, ALLY}

@export var display_name := "Action"
@export var cooldown_time := 0.0
@export var target_type := TargetType.ENEMY

var cooldown_timer := 0.0

# Public interface
func execute(caster: Node, target: Damageable) -> bool:
	if cooldown_timer > 0:
		return false
	
	# Only validate target if action requires one
	if target_type != TargetType.SELF and not _is_valid_target(target):
		return false
		
	cooldown_timer = cooldown_time
	_perform_action(caster, target)
	return true

# Cooldown management (now public)
func update_cooldown(delta: float) -> bool:
	if cooldown_timer > 0:
		cooldown_timer = max(0, cooldown_timer - delta)
		return cooldown_timer == 0
	return false

# Helper methods
func _is_valid_target(target: Damageable) -> bool:
	match target_type:
		TargetType.SELF: return true
		TargetType.ALLY, TargetType.ENEMY: return target != null
		_: return false

func _perform_action(_caster: Node, _target: Damageable) -> void:
	push_warning("Base Action has no effect!")
