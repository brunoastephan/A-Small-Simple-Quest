class_name Enemy
extends Damageable  # Inherits from our interface

@export var resource : EnemyResource

func _ready():
	if resource:
		max_health = resource.max_health
		current_health = max_health
