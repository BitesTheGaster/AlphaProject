class_name LootTable
extends Resource
##

@export var drops: Array[ItemDrop] = []
@export var min_drops: int = 1
@export var max_drops: int = 1
@export var luck_scaling: float = 0.0


func get_loot(luck: float = 0.0) -> Array[Item]:
	if drops.is_empty():
		return []
	
	var result: Array[Item] = []
	var drops_count: int = randi_range(min_drops, max_drops)
	
	var available_drops: Array[ItemDrop] = _apply_luck_to_drops(luck)
	
	for i in range(drops_count):
		if available_drops.is_empty():
			break
			
		var selected_drop: ItemDrop = \
				_select_weighted_random(available_drops)
		if selected_drop:
			result.append(selected_drop.item.duplicate())
			available_drops.erase(selected_drop)
	
	return result


func _apply_luck_to_drops(luck: float) -> Array[ItemDrop]:
	if luck == 0.0 or luck_scaling == 0.0:
		return drops.duplicate()
	
	var modified_drops: Array[ItemDrop] = []
	for drop in drops:
		var modified_drop = drop.duplicate()
		modified_drop.weight *= (1.0 + luck * luck_scaling)
		modified_drop.chance = min(1.0, drop.chance * \
				(1.0 + luck * luck_scaling))
		modified_drops.append(modified_drop)
	
	return modified_drops


func _select_weighted_random(drops_array: Array[ItemDrop]) \
		-> ItemDrop:
	var possible_drops: Array[ItemDrop] = []
	for drop in drops_array:
		if randf() <= drop.chance:
			possible_drops.append(drop)
	
	if possible_drops.is_empty():
		return null
	
	var total_weight: float = 0.0
	for drop in possible_drops:
		total_weight += drop.weight
	
	var rando = randf_range(0, total_weight)
	var current_weight = 0.0
	
	for drop in possible_drops:
		current_weight += drop.weight
		if rando <= current_weight:
			return drop
	
	return possible_drops.back()
