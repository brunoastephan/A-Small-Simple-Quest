# DefendAction.gd
class_name DefendAction
extends Action

func _init():
	display_name = "Defend"
	cooldown_time = 1.5  # 1.5 second cooldown

func _perform_action() -> String:
	print("🛡️ Defended!")
	return display_name
