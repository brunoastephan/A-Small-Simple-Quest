extends Control

@export var battle_scene : PackedScene

func _ready():
	# Focus the button for keyboard/gamepad support
	$Button.grab_focus()

func _on_button_pressed():
	if battle_scene:
		get_tree().change_scene_to_packed(battle_scene)
	else:
		push_error("No battle scene assigned!")
