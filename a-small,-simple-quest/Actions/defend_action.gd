class_name DefendAction
extends Action

func _init():
	display_name = "Defend"  # Default value

func execute():
	print("🛡️ Defended!")
	return display_name
