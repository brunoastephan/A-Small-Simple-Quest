class_name DefendAction
extends Action

@export var defense_power := 5    # Damage reduction amount
@export var duration := 2.0       # How long defense lasts (seconds)

func _init():
	display_name = "Defend"
	cooldown_time = 1.5
	target_type = TargetType.SELF

func _perform_action(caster: Node, _target: Damageable) -> void:
	if caster.has_method("add_timed_defense"):
		caster.add_timed_defense(defense_power, duration)
		print("🛡️ Defense +", defense_power, " for ", duration, "s")
