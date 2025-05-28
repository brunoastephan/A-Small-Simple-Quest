extends Node2D

@export var radius := 100.0
@export var animation_duration := 0.3
@export var selected_scale := Vector2(1.5, 1.5)
@export var normal_scale := Vector2(1.0, 1.0)
@export var action_list : ActionList
@export var pool_manager : ActionPoolManager  # Add this below your other @exports
@onready var current_actions : Array[Action] = []  # Add this with your other vars

var option_labels := []
var is_rotating := false
var current_index := 0
var tween: Tween

func _ready():
	current_actions = pool_manager.refresh_actions()
	_create_labels()
	layout_options()

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
	
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var angle_step = TAU / option_labels.size()
	
	for i in range(option_labels.size()):
		var start_angle = -angle_step * ((i - (current_index - 1)) % option_labels.size())
		var end_angle = start_angle + angle_step
		var label = option_labels[i]
		
		tween.parallel().tween_method(
			func(a): label.position = Vector2(cos(a), sin(a)) * radius,
			start_angle, end_angle, animation_duration
		)
		tween.parallel().tween_property(
			label, "scale", 
			selected_scale if i == current_index else normal_scale,
			animation_duration
		)
	
	tween.finished.connect(func(): is_rotating = false)

func _input(event):
	if is_rotating: return
	if event.is_action_pressed("ui-accept"): rotate_options()
	elif event.is_action_pressed("ui-select"):
		var selected = current_actions[current_index]  # Changed from action_list
		selected.execute()
		current_actions = pool_manager.refresh_actions()  # Refresh on execute
		_create_labels()  # Rebuild labels
		layout_options()
