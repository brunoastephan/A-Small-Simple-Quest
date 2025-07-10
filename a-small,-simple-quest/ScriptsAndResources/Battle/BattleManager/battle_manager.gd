class_name BattleManager
extends Node

@export var player_scene : PackedScene
@export var enemy_scene : PackedScene
@export var win_scene : PackedScene
@export var lose_scene : PackedScene
@export var default_job : Job
@export var default_enemy : EnemyResource

var current_player : Player
var current_enemy : Enemy

func _ready():
	start_battle()

func start_battle():
	# Spawn player
	current_player = player_scene.instantiate()
	current_player.job = default_job
	add_child(current_player)
	current_player.died.connect(_on_player_died)
	current_player.position = Vector2(300, 300)
	
	# Spawn enemy
	current_enemy = enemy_scene.instantiate()
	current_enemy.resource = default_enemy
	add_child(current_enemy)
	current_enemy.died.connect(_on_enemy_died)
	current_enemy.position = Vector2(800, 300)
	
	# CRITICAL: Set up references and groups
	current_enemy.add_to_group("enemies")
	current_enemy.player_ref = current_player  # Give enemy access to player
	current_player.circular_menu.show_menu()  # Make sure menu is visible

func _on_player_died():
	get_tree().change_scene_to_packed(lose_scene)

func _on_enemy_died():
	get_tree().change_scene_to_packed(win_scene)

func cleanup():
	if current_player:
		current_player.queue_free()
	if current_enemy:
		current_enemy.queue_free()
