class_name ActionPool
extends Resource

@export var possible_actions : Array[Action] = []
@export var action_probabilities : Array[float] = []

# Ensures probabilities are always normalized (0-1 range)
func normalize_probabilities():
	var total = action_probabilities.reduce(func(a, b): return a + b, 0.0)
	if total > 0:
		action_probabilities = action_probabilities.map(func(p): return p / total)

# Generates 4 actions respecting probabilities
func generate_action_set() -> Array[Action]:
	var result : Array[Action] = []
	var candidates = _get_weighted_candidates()
	
	for i in min(4, candidates.size()):
		result.append(candidates[i])
	return result

# Helper for weighted random selection
func _get_weighted_candidates() -> Array[Action]:
	var candidates : Array[Action] = []
	var temp_actions = possible_actions.duplicate()
	var temp_probs = action_probabilities.duplicate()
	
	while temp_actions.size() > 0:
		var total = temp_probs.reduce(func(a, b): return a + b, 0.0)
		var roll = randf_range(0.0, total)
		var cumulative = 0.0
		
		for i in temp_actions.size():
			cumulative += temp_probs[i]
			if roll <= cumulative:
				candidates.append(temp_actions[i])
				temp_actions.remove_at(i)
				temp_probs.remove_at(i)
				break
				
	return candidates
