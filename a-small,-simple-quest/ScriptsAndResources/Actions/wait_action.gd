class_name WaitAction
extends Action

func _init():
	display_name = "Wait"
	cooldown_time = 0.5
	target_type = TargetType.SELF

func _perform_action(_caster: Node, _target: Damageable) -> void:
	print("⏳ Waited")
