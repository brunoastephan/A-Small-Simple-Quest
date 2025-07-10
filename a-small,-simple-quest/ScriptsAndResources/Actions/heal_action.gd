class_name HealAction
extends Action

@export var heal_amount := 10  # Editable in inspector

func _init():
	display_name = "Heal"
	cooldown_time = 3.0
	target_type = TargetType.SELF

func _perform_action(caster: Node, _target: Damageable) -> void:
	if caster.has_method("heal"):
		caster.heal(heal_amount)
		print("💚 Healed for ", heal_amount)
