class_name EquipableItem
extends Item
##


func equip(target: CharacterBody2D):
	if target is Player or target is Enemy:
		pass
		# do something
