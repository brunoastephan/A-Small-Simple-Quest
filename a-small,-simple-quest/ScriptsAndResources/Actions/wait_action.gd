# WaitAction.gd
class_name WaitAction
extends Action

func _init():
	display_name = "Wait"
	cooldown_time = 0.5  # 0.5 second cooldown

func _perform_action() -> String:
	print("⏳ Waited")
	return display_name
