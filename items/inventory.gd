class_name Inventory
extends Resource

var items: Dictionary[int, Item] = {
	1: preload("res://resources/items/weapons/golden_short_sword.tres"),
	2: Item.new(),
	3: Item.new(),
	4: preload("res://resources/items/weapons/fire_sword.tres"),
	5: Item.new(),
	6: Item.new(),
	7: Item.new(),
	8: Item.new(),
	9: Item.new(),
	10: Item.new(),
	11: Item.new(),
	
	11+1: Item.new(),
	11+2: Item.new(),
	11+3: Item.new(),
	11+4: Item.new(),
	11+5: Item.new(),
	11+6: Item.new(),
	11+7: Item.new(),
	11+8: Item.new(),
	11+9: Item.new(),
	11+10: Item.new(),
	11+11: Item.new(),
	
	2*11+1: Item.new(),
	2*11+2: Item.new(),
	2*11+3: Item.new(),
	2*11+4: Item.new(),
	2*11+5: Item.new(),
	2*11+6: Item.new(),
	2*11+7: Item.new(),
	2*11+8: Item.new(),
	2*11+9: Item.new(),
	2*11+10: Item.new(),
	2*11+11: Item.new(),
	
	3*11+1: Item.new(),
	3*11+2: Item.new(),
	3*11+3: Item.new(),
	3*11+4: Item.new(),
	3*11+5: Item.new(),
	3*11+6: Item.new(),
	3*11+7: Item.new(),
	3*11+8: Item.new(),
	3*11+9: Item.new(),
	3*11+10: Item.new(),
	3*11+11: Item.new(),
}

var weapon: Weapon = preload("res://resources/items/weapons/iron_short_sword.tres")
#var magic1: Spell
#var magic2: Spell
#var magic3: Spell
#var trinkets: Array[Trinket]
