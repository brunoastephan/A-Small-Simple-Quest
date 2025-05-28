# action.gd
class_name Action
extends Resource

@export var display_name := "Action":
	set(value):
		display_name = value
		emit_changed()  # Important for resource changes

@export var cost := 1

func execute():
	print("Executed: ", display_name)
	return display_name
