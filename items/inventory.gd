class_name Inventory
extends Resource

var items: Dictionary[int, Item] = {
	1: Global.items[Global.EMPTY],
	2: Global.items[Global.EMPTY],
	3: Global.items[Global.EMPTY],
	4: Global.items[Global.EMPTY],
	5: Global.items[Global.EMPTY],
	6: Global.items[Global.EMPTY],
	7: Global.items[Global.EMPTY],
	8: Global.items[Global.EMPTY],
	9: Global.items[Global.EMPTY],
	10: Global.items[Global.EMPTY],
	11: Global.items[Global.EMPTY],
	
	11+1: Global.items[Global.EMPTY],
	11+2: Global.items[Global.EMPTY],
	11+3: Global.items[Global.EMPTY],
	11+4: Global.items[Global.EMPTY],
	11+5: Global.items[Global.EMPTY],
	11+6: Global.items[Global.EMPTY],
	11+7: Global.items[Global.EMPTY],
	11+8: Global.items[Global.EMPTY],
	11+9: Global.items[Global.EMPTY],
	11+10: Global.items[Global.EMPTY],
	11+11: Global.items[Global.EMPTY],
	
	2*11+1: Global.items[Global.EMPTY],
	2*11+2: Global.items[Global.EMPTY],
	2*11+3: Global.items[Global.EMPTY],
	2*11+4: Global.items[Global.EMPTY],
	2*11+5: Global.items[Global.EMPTY],
	2*11+6: Global.items[Global.EMPTY],
	2*11+7: Global.items[Global.EMPTY],
	2*11+8: Global.items[Global.EMPTY],
	2*11+9: Global.items[Global.EMPTY],
	2*11+10: Global.items[Global.EMPTY],
	2*11+11: Global.items[Global.EMPTY],
	
	3*11+1: Global.items[Global.EMPTY],
	3*11+2: Global.items[Global.EMPTY],
	3*11+3: Global.items[Global.EMPTY],
	3*11+4: Global.items[Global.EMPTY],
	3*11+5: Global.items[Global.EMPTY],
	3*11+6: Global.items[Global.EMPTY],
	3*11+7: Global.items[Global.EMPTY],
	3*11+8: Global.items[Global.EMPTY],
	3*11+9: Global.items[Global.EMPTY],
	3*11+10: Global.items[Global.EMPTY],
	3*11+11: Global.items[Global.EMPTY],
}

var weapon: Weapon = Global.weapons[Global.IRON_SHORT_SWORD]
#var magic1: Spell
#var magic2: Spell
#var magic3: Spell
#var trinkets: Array[Trinket]


func get_free_slot() -> int:
	for i in range(1, 44+1):
		if items[i] == Global.items[Global.EMPTY]:
			return i
	
	return 0
