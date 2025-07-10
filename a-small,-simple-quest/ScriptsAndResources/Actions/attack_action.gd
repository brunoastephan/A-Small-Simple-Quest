class_name AttackAction
extends Action

func _init():
	display_name = "Attack"
	cooldown_time = 2.0
	target_type = TargetType.ENEMY

func _perform_action(caster: Node, target: Damageable) -> void:
	if target and caster.has_method("get_attack_damage"):
		var damage = caster.get_attack_damage()
		print("DEBUG - Attempting attack: ", {
			"caster": caster.name,
			"target": target.name,
			"damage": damage,
			"target_health_before": target.current_health
		})
		target.take_damage(damage)
		print("⚔️ Attacked ", target.name, " for ", damage, " damage. New health: ", target.current_health)
	else:
		var error = "Attack failed - "
		if not target: error += "no valid target"
		elif not caster.has_method("get_attack_damage"): error += "caster missing get_attack_damage()"
		push_error(error)
