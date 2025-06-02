# AttackAction.gd
class_name AttackAction
extends Action

func _init():
	display_name = "Attack"
	cooldown_time = 2.0  # 2 second cooldown

func _perform_action() -> String:
	print("⚔️ Attacked!")
	return display_name
