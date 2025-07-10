class_name DefendAction
extends Action

func _init():
	display_name = "Defend"
	cooldown_time = 1.5
	target_type = TargetType.SELF

func _perform_action(caster: Node, _target: Damageable) -> void:
	if caster.has_method("heal") and caster.has_method("get_defense_value"):
		caster.heal(caster.get_defense_value())
		print("🛡️ Defended!")
	else:
		push_error("DefendAction: Invalid caster - missing heal/get_defense_value methods")
