class_name Inventory
extends Resource

var items: Dictionary[int, Item] = {
	1: Items.EMPTY,
	2: Items.EMPTY,
	3: Items.EMPTY,
	4: Items.EMPTY,
	5: Items.EMPTY,
	6: Items.EMPTY,
	7: Items.EMPTY,
	8: Items.EMPTY,
	9: Items.EMPTY,
	10: Items.EMPTY,
	11: Items.EMPTY,
	
	11+1: Items.EMPTY,
	11+2: Items.EMPTY,
	11+3: Items.EMPTY,
	11+4: Items.EMPTY,
	11+5: Items.EMPTY,
	11+6: Items.EMPTY,
	11+7: Items.EMPTY,
	11+8: Items.EMPTY,
	11+9: Items.EMPTY,
	11+10: Items.EMPTY,
	11+11: Items.EMPTY,
	
	2*11+1: Items.EMPTY,
	2*11+2: Items.EMPTY,
	2*11+3: Items.EMPTY,
	2*11+4: Items.EMPTY,
	2*11+5: Items.EMPTY,
	2*11+6: Items.EMPTY,
	2*11+7: Items.EMPTY,
	2*11+8: Items.EMPTY,
	2*11+9: Items.EMPTY,
	2*11+10: Items.EMPTY,
	2*11+11: Items.EMPTY,
	
	3*11+1: Items.EMPTY,
	3*11+2: Items.EMPTY,
	3*11+3: Items.EMPTY,
	3*11+4: Items.EMPTY,
	3*11+5: Items.EMPTY,
	3*11+6: Items.EMPTY,
	3*11+7: Items.EMPTY,
	3*11+8: Items.EMPTY,
	3*11+9: Items.EMPTY,
	3*11+10: Items.EMPTY,
	3*11+11: Items.EMPTY,
}

var weapon: Weapon = Weapons.IRON_SHORT_SWORD
#var magic1: Spell
#var magic2: Spell
#var magic3: Spell
#var trinkets: Array[Trinket]


func get_free_slot() -> int:
	for i in range(1, 44+1):
		if items[i] == Items.EMPTY:
			return i
	
	return 0
