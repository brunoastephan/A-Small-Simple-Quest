class_name Enemy
extends Damageable

@export var resource : EnemyResource
@onready var health_bar = $HealthBar/ProgressBar
@onready var health_text = $HealthBar/Label
@onready var attack_timer = $AttackTimer

var player_ref : Player

func _ready():
	if resource:
		max_health = resource.max_health
		current_health = max_health
		update_health_display()
		attack_timer.wait_time = resource.attack_cooldown
		attack_timer.start()
	
	health_changed.connect(_on_health_changed)
	attack_timer.timeout.connect(_attempt_attack)

func _attempt_attack():
	if not is_instance_valid(player_ref):
		# Find player if we don't have a reference
		player_ref = get_tree().get_first_node_in_group("player")
		if not player_ref: return
	
	if randf() <= resource.attack_chance:
		_attack_player()

func _attack_player():
	print(resource.display_name, " attacks!")
	player_ref.take_damage(resource.attack_damage)
	# Add visual attack animation here later

func _on_health_changed(_new_health, _max_health):
	update_health_display()

func update_health_display():
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
	if health_text:
		health_text.text = "%d/%d" % [current_health, max_health]
