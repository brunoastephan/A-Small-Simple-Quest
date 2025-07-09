class_name CircularMenu
extends Node2D

@export var radius := 100.0
@export var animation_duration := 0.3
@export var selected_scale := Vector2(1.5, 1.5)
@export var normal_scale := Vector2(1.0, 1.0)
@export var pool_manager : ActionPoolManager

@onready var current_actions : Array[Action] = []
var option_labels := []
var is_rotating := false
var current_index := 0
var tween: Tween
var is_menu_locked := false

func _ready():
	refresh_menu()

func refresh_menu():
	current_actions = pool_manager.refresh_actions()
	_create_labels()
	layout_options()
	# Always show menu when refreshed
	show_menu()

func _create_labels():
	for label in option_labels:
		label.queue_free()
	option_labels.clear()
	
	for action in current_actions:
		var label = Label.new()
		label.text = action.display_name
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(label)
		option_labels.append(label)

func _process(delta):
	var needs_refresh = false
	
	# Update all cooldowns
	for action in current_actions:
		if action.cooldown_timer > 0:
			if action.update_cooldown(delta):
				needs_refresh = true
	
	if needs_refresh:
		refresh_menu()

func show_menu():
	visible = true
	is_menu_locked = false

func hide_menu():
	visible = false
	is_menu_locked = true

func _input(event):
	if is_rotating or is_menu_locked:
		return
	
	if event.is_action_pressed("ui-accept"):
		rotate_options()
	elif event.is_action_pressed("ui-select"):
		var selected = current_actions[current_index]
		if selected.execute():  # Returns true if executed
			hide_menu()
		else:
			print(selected.display_name, " is on cooldown!")
func layout_options():
	var angle_step = TAU / option_labels.size()
	for i in range(option_labels.size()):
		var visual_index = (i - current_index) % option_labels.size()
		var angle = -angle_step * visual_index
		var label = option_labels[i]
		label.position = Vector2(cos(angle), sin(angle)) * radius
		label.scale = selected_scale if visual_index == 0 else normal_scale

func rotate_options():
	if is_rotating: return
	is_rotating = true
	current_index = (current_index + 1) % option_labels.size()
	
	# Store current label references
	var labels = option_labels.duplicate()
	var target_index = current_index
	
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var angle_step = TAU / labels.size()
	
	for i in labels.size():
		var start_angle = -angle_step * ((i - (target_index - 1)) % labels.size())
		var end_angle = start_angle + angle_step
		
		# Use weak reference to prevent memory issues
		var weak_label = weakref(labels[i])
		
		tween.parallel().tween_method(
			func(a): 
				var label = weak_label.get_ref()
				if label:
					label.position = Vector2(cos(a), sin(a)) * radius,
			start_angle, end_angle, animation_duration
		)
		tween.parallel().tween_property(
			labels[i], "scale", 
			selected_scale if i == target_index else normal_scale,
			animation_duration
		)
	
	tween.finished.connect(func(): is_rotating = false)
