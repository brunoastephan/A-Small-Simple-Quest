class_name Damageable
extends Node2D

signal health_changed(new_health, max_health)
signal died()

@export var max_health := 100
@onready var current_health := max_health

func take_damage(amount: int):
	current_health -= amount
	current_health = max(0, current_health)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		die()

func heal(amount: int):
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)

func die():
	died.emit()
	queue_free()
