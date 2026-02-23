extends Node
## Global variables

enum Names {
	EMPTY,
	IRON_SHORT_SWORD,
	GOLDEN_SHORT_SWORD,
	FIRE_SWORD,
	IRON_SWORD,
}

const EMPTY: Names = Names.EMPTY
const IRON_SHORT_SWORD: Names = Names.IRON_SHORT_SWORD
const GOLDEN_SHORT_SWORD: Names = Names.GOLDEN_SHORT_SWORD
const FIRE_SWORD: Names = Names.FIRE_SWORD
const IRON_SWORD: Names = Names.IRON_SWORD

var items: Dictionary[Names, Item] = {
	EMPTY: Item.new(),
	
}

var weapons: Dictionary[Names, Weapon] = {
	EMPTY:
			Weapon.new(),
	IRON_SHORT_SWORD: preload(
			"res://resources/items/weapons/iron_short_sword.tres"),
	GOLDEN_SHORT_SWORD: preload(
			"res://resources/items/weapons/golden_short_sword.tres"),
	FIRE_SWORD: preload(
		"res://resources/items/weapons/fire_sword.tres"),
	IRON_SWORD: preload(
		"res://resources/items/weapons/iron_sword.tres"),
	
	#TEMPLATE: preload(
		#),
	
}

var inventory: Inventory
var current_slot = 0

func _ready() -> void:
	inventory = Inventory.new()
