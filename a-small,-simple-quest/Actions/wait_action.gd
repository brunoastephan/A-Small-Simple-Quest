class_name WaitAction
extends Action

func _init():
	display_name = "Wait"  # Default value

func execute():
	print("⏳ Waited")
	return display_name
