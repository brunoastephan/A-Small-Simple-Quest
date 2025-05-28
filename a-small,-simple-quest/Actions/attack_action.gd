class_name AttackAction
extends Action

func _init():
	display_name = "Attack"  # Default value, can be overridden in inspector

func execute():
	print("⚔️ Attacked!")
	return display_name
