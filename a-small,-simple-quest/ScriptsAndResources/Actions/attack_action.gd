class_name AttackAction
extends Action

func _init():
	display_name = "Attack"
	cooldown_time = 2.0
	target_type = TargetType.ENEMY

func _perform_action(caster: Node, target: Damageable) -> void:
	if target:
		target.take_damage(caster.job.attack_damage)
		print("⚔️ Attacked ", target.name)
