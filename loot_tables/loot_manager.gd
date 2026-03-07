extends Node
##

enum Names {
	ORC,
	KNIGHT_BOSS,
}

const ORC = Names.ORC
const KNIGHT_BOSS = Names.KNIGHT_BOSS

var loot_tables: Dictionary[Names, LootTable] = {
	ORC: preload("res://resources/loot_tables/orc.tres"),
	KNIGHT_BOSS: preload("res://resources/loot_tables/knight_boss.tres"),
}

var chest_loot_tables: Dictionary[int, LootTable] = {
	0: preload("res://resources/loot_tables/chest_tier_0.tres")
}

func get_chest_loot(tier: int, luck: float = 0.0) -> Array[Item]:
	if chest_loot_tables.has(tier):
		return chest_loot_tables[tier].get_loot(luck)
	else:
		return []
