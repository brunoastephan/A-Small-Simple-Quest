class_name EndScreen
extends Control

func _ready():
	$Button.grab_focus()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
