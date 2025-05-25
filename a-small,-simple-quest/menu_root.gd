extends Node2D

@export var radius := 100.0
@export var animation_duration := 0.3
@export var selected_scale := Vector2(1.5, 1.5)
@export var normal_scale := Vector2(1.0, 1.0)

var option_labels := []
var is_rotating := false
var current_index := 0
var tween: Tween

func _ready():
	option_labels = [$Attack, $Defend, $Wait]
	layout_options()

func layout_options():
	var angle_step = TAU / option_labels.size()
	
	for i in range(option_labels.size()):
		var visual_index = (i - current_index) % option_labels.size()
		var angle = -angle_step * visual_index  # Negative for clockwise
		var label = option_labels[i]
		label.position = Vector2(cos(angle), sin(angle)) * radius
		label.scale = selected_scale if visual_index == 0 else normal_scale

func rotate_options():
	if is_rotating:
		return

	is_rotating = true
	var prev_index = current_index
	current_index = (current_index + 1) % option_labels.size()
	
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	var angle_step = TAU / option_labels.size()
	var start_angles = []
	
	# Store starting angles and scales
	for i in range(option_labels.size()):
		var visual_index = (i - prev_index) % option_labels.size()
		start_angles.append(-angle_step * visual_index)
	
	# Animate each label
	for i in range(option_labels.size()):
		var label = option_labels[i]
		var start_angle = start_angles[i]
		var end_angle = start_angle + angle_step
		
		# Position animation (circular path)
		tween.parallel().tween_method(
			func(angle): 
				label.position = Vector2(cos(angle), sin(angle)) * radius,
			start_angle,
			end_angle,
			animation_duration
		)
		
		# Scale animation - separate tween for smoother control
		var is_becoming_selected = (i - current_index) % option_labels.size() == 0
		var is_losing_selection = (i - prev_index) % option_labels.size() == 0
		
		if is_becoming_selected:
			tween.parallel().tween_property(label, "scale", selected_scale, animation_duration * 0.8)
		elif is_losing_selection:
			tween.parallel().tween_property(label, "scale", normal_scale, animation_duration * 0.5)

	tween.finished.connect(_on_rotation_done)

func _on_rotation_done():
	is_rotating = false
	layout_options()  # Ensure perfect final positions

func _input(event):
	if is_rotating:
		return

	if event.is_action_pressed("ui-accept"):  # Z key
		rotate_options()
	elif event.is_action_pressed("ui-select"):  # X key
		var selected_label = option_labels[current_index]
		print("Selected:", selected_label.text)
