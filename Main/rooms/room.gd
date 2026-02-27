class_name Room
extends Node2D
##

signal spawn_orc(orc: OrcEnemy)

const CHUNK_SIZE := Vector2i(16, 16)

@onready var orc_scene = preload("res://enemies/orc/orc_enemy.tscn")
@onready var walls: TileMapLayer = %Walls
@onready var floor: TileMapLayer = %Floor
@onready var decor: TileMapLayer = %Decor


func generate(floor_size: Vector2i):
	for x in range(-roundi(floor_size.x/2.0)+1, \
			roundi(floor_size.x/2.0)):
		for y in range(-roundi(floor_size.y/2.0)+1, \
				roundi(floor_size.y/2.0)):
			var left: bool = -roundi(floor_size.x/2.0)+1 != x
			var right: bool = roundi(floor_size.x/2.0)-1 != x
			var up: bool = -roundi(floor_size.y/2.0)+1 != y
			var down: bool = roundi(floor_size.y/2.0)-1 != y
			_gen_chunk(Vector2i(x, y), left, right, up, down)


func _gen_chunk(chuck_pos: Vector2i, left: bool, right: bool, up: bool, down: bool):
	var center: Vector2i = chuck_pos * CHUNK_SIZE
	
	# main room
	var main_room_size := Vector2i(
		randi_range(6, CHUNK_SIZE.x-4),
		randi_range(6, CHUNK_SIZE.y-4)
	)
	_rect(center, main_room_size)
	if center:
		var rando: float = randf()
		if rando < 0.7:
			_spawn_orc(center*24, main_room_size*24-Vector2i(24*2, 24*2), 0.15)
		else:
			_set_chest(center)
	
	if left:
		_rect(
			Vector2i(
				center.x - 8,
				center.y
			),
			Vector2i(
				16 - main_room_size.x/2,
				3
			)
		)
	if right:
		_rect(
			Vector2i(
				center.x + 8,
				center.y
			),
			Vector2i(
				16 - main_room_size.x/2,
				3
			)
		)
	if up:
		_rect(
			Vector2i(
				center.x,
				center.y - 8
			),
			Vector2i(
				3,
				16 - main_room_size.y/2
			)
		)
	if down:
		_rect(
			Vector2i(
				center.x,
				center.y + 8
			),
			Vector2i(
				3,
				16 - main_room_size.y/2
			)
		)

func _rect(pos: Vector2i, size: Vector2i):
	var wall_cells: Array[Vector2i] = []
	var floor_cells: Array[Vector2i] = []
	
	var room_corner: Vector2i = size/-2
	
	for x in range(0, size.x):
		for y in range(0, size.y):
			wall_cells.append(Vector2i(room_corner.x + pos.x + x, \
					room_corner.y + pos.y + y))
			if y != 0:
				floor_cells.append(Vector2i(room_corner.x + pos.x + x, \
						room_corner.y + pos.y + y))
				decor.set_cell(Vector2i(room_corner.x + pos.x + x, \
						room_corner.y + pos.y + y), 1, Vector2i(0, 2))
	
	walls.set_cells_terrain_connect(wall_cells, 0, 0, false)
	floor.set_cells_terrain_connect(floor_cells, 0, 0)


func _spawn_orc(pos: Vector2, size: Vector2, frec: float):
	var room_corner: Vector2 = size/-2
	for x in range(0, size.x, 24):
		for y in range(0, size.y, 24):
			if randf() > frec:
				continue
			var orc_pos := Vector2(room_corner.x + pos.x + x, \
					room_corner.y + pos.y + y)
			var orc: OrcEnemy = orc_scene.instantiate()
			orc.global_position = orc_pos
			spawn_orc.emit(orc)
			

func _set_chest(coords: Vector2i):
	decor.set_cell(coords, 1, Vector2i(1, 0))
