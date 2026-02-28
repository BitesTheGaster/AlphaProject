class_name Room
extends Node2D
##

signal spawn_orc(orc: OrcEnemy)

const CHUNK_SIZE := Vector2i(16, 16)

var room_grid: Dictionary[Vector2i, Dictionary] = {}

@onready var orc_scene = preload("res://enemies/orc/orc_enemy.tscn")
@onready var walls: TileMapLayer = %Walls
@onready var floor: TileMapLayer = %Floor
@onready var decor: TileMapLayer = %Decor


func generate(floor_size: Vector2i):
	var room_grid: Dictionary[Vector2i, Dictionary] = {}
	
	for x in range(-roundi(floor_size.x/2.0)+1, roundi(floor_size.x/2.0)):
		for y in range(-roundi(floor_size.y/2.0)+1, roundi(floor_size.y/2.0)):
			room_grid[Vector2i(x, y)] = {
				"pos": Vector2i(x, y),
				"left": false,
				"right": false,
				"up": false,
				"down": false,
				"visited": false,
				"has_ladder": false,
			}
	
	_generate_maze(room_grid, Vector2i.ZERO)
	_add_extra_passages(room_grid, 0.15)
	
	var farthest_pos = _find_farthest_room(room_grid, Vector2i.ZERO)
	room_grid[farthest_pos].has_ladder = true
	
	for room in room_grid.values():
		_gen_chunk(room.pos, room.left, room.right, room.up, room.down, room.has_ladder)


func _find_farthest_room(room_grid: Dictionary[Vector2i, Dictionary], \
		start_pos: Vector2i) -> Vector2i:
	var distances = {}
	var queue = [start_pos]
	distances[start_pos] = 0
	
	while queue.size() > 0:
		var current = queue.pop_front()
		var current_dist = distances[current]
		
		var dirs = [
			Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)
		]
		
		for dir in dirs:
			var neighbor = current + dir
			if room_grid.has(neighbor) and not distances.has(neighbor):
				# Проверяем, есть ли проход между комнатами
				if (dir == Vector2i(1, 0) and room_grid[current].right) or \
				   (dir == Vector2i(-1, 0) and room_grid[current].left) or \
				   (dir == Vector2i(0, 1) and room_grid[current].down) or \
				   (dir == Vector2i(0, -1) and room_grid[current].up):
					distances[neighbor] = current_dist + 1
					queue.append(neighbor)
		
	var max_dist = -1
	var farthest = start_pos
	for pos in distances:
		if distances[pos] > max_dist:
			max_dist = distances[pos]
			farthest = pos
	
	return farthest


func _generate_maze(room_grid: Dictionary[Vector2i, Dictionary], \
		current_pos: Vector2i):
	var current = room_grid[current_pos]
	current.visited = true
	
	var dirs = [
		{
			"dir": "right",
			"pos": Vector2i(1, 0),
			"opposite": "left",
		},
		{
			"dir": "left",
			"pos": Vector2i(-1, 0),
			"opposite": "right",
		},
		{
			"dir": "down",
			"pos": Vector2i(0, 1),
			"opposite": "up",
		},
		{
			"dir": "up",
			"pos": Vector2i(0, -1),
			"opposite": "down",
		},
	]
	dirs.shuffle()
	
	for dir_info in dirs:
		var neighbor_pos = current_pos + dir_info.pos
		
		if not room_grid.has(neighbor_pos):
			continue
			
		var neighbor = room_grid[neighbor_pos]
		
		if not neighbor.visited:
			current[dir_info.dir] = true
			neighbor[dir_info.opposite] = true
			_generate_maze(room_grid, neighbor_pos)


func _add_extra_passages(room_grid: Dictionary[Vector2i, Dictionary], chance: float):
	for pos in room_grid.keys():
		var current = room_grid[pos]
		
		var neighbors = [
			{"dir": "right", "pos": Vector2i(1, 0), "opposite": "left"},
			{"dir": "down", "pos": Vector2i(0, 1), "opposite": "up"}
		]
		
		for nb in neighbors:
			var neighbor_pos = pos + nb.pos
			if not room_grid.has(neighbor_pos):
				continue
				
			var neighbor = room_grid[neighbor_pos]
			
			if not current[nb.dir] and randf() < chance:
				current[nb.dir] = true
				neighbor[nb.opposite] = true


func _gen_chunk(chuck_pos: Vector2i, left: bool, right: bool, up: bool, down: bool, has_ladder: bool):
	var center: Vector2i = chuck_pos * CHUNK_SIZE
	
	# main room
	var main_room_size := Vector2i(
		randi_range(6, CHUNK_SIZE.x-4),
		randi_range(6, CHUNK_SIZE.y-4)
	)
	_rect(center, main_room_size)
	if center:
		var rando: float = randf()
		if rando < 0.9:
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
	if has_ladder:
		decor.set_cell(
			Vector2(
				center.x,
				center.y - main_room_size.y/2
			),
			1,
			Vector2i(2, 2)
		)
		walls.set_cell(
			Vector2(
				center.x,
				center.y - main_room_size.y/2
			),
			0,
			Vector2i(2, 2)
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
