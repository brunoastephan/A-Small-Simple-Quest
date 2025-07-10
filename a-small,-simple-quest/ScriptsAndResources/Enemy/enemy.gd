class_name Enemy
extends Damageable

@export var resource : EnemyResource
@onready var health_bar = $HealthBar/ProgressBar
@onready var health_text = $HealthBar/Label

func _ready():
	if resource:
		max_health = resource.max_health
		current_health = max_health
		update_health_display()
	
	# Connect health changed signal
	health_changed.connect(_on_health_changed)

func _on_health_changed(_new_health, _max_health):
	update_health_display()

func update_health_display():
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
	if health_text:
		health_text.text = "%d/%d" % [current_health, max_health]
