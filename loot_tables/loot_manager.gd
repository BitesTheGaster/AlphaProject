extends Node
##

enum Names {
	ORC
}

const ORC = Names.ORC

var loot_tables: Dictionary[Names, LootTable] = {
	ORC: preload("res://resources/loot_tables/orc.tres"),
}

var chest_loot_tables: Dictionary[int, LootTable] = {
	0: preload("res://resources/loot_tables/chest_tier_0.tres")
}

func get_chest_loot(tier: int, luck: float = 0.0) -> Array[Item]:
	if chest_loot_tables.has(tier):
		return chest_loot_tables[tier].get_loot(luck)
	else:
		return []
