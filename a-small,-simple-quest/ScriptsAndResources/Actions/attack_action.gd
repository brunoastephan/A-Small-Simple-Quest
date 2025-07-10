class_name AttackAction
extends Action

@export var attack_power := 10  # Directly editable damage value

func _init():
	display_name = "Attack"
	cooldown_time = 2.0
	target_type = TargetType.ENEMY

func _perform_action(caster: Node, target: Damageable) -> void:
	if target:
		target.take_damage(attack_power)
		print("⚔️ Attacked for ", attack_power, " damage")
