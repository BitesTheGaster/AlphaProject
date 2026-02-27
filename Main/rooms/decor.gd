class_name Decor
extends TileMapLayer
##

signal chest_opened(chest_coords: Vector2, item: Item)


func open_chest(chest_coords: Vector2i, tier: int):
	set_cell(chest_coords, 1, Vector2i(4, 0))
	chest_opened.emit(chest_coords*24, tier)
