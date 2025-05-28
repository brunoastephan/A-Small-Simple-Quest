class_name ActionList
extends Resource

@export var possible_actions : Array[Action] = []
@export var action_probabilities : Array[float] = []

func generate_action_set() -> Array[Action]:  # Explicit return type
	var result : Array[Action] = []  # Explicit typed array
	var temp_actions = possible_actions.duplicate()
	var temp_probs = action_probabilities.duplicate()
	
	# Normalize probabilities
	var total_weight := 0.0
	for prob in temp_probs:
		total_weight += prob
	
	# Select 4 unique actions
	for i in 4:
		if temp_actions.size() == 0: break
		
		var roll := randf_range(0.0, total_weight)
		var cumulative := 0.0
		
		for j in temp_actions.size():
			cumulative += temp_probs[j]
			if roll <= cumulative:
				result.append(temp_actions[j])
				total_weight -= temp_probs[j]
				temp_actions.remove_at(j)
				temp_probs.remove_at(j)
				break
				
	return result
