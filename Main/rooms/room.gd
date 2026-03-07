class_name Room
extends Node2D
##

signal spawn_orc(orc: OrcEnemy)
signal boss_agro(target: Player)

enum Bosses {
	ORC,
	KNIGHT,
}

const CHUNK_SIZE := Vector2i(16, 16)

var room_grid: Dictionary[Vector2i, Dictionary] = {}
var gate_pos: Vector2i = Vector2i.ZERO
var gate_frame: int = 0
var boss_room: Vector2i
var gate_frames: Array[Vector2i] = [
	Vector2i(2, 2),
	Vector2i(1, 4),
	Vector2i(2, 4),
]
var boss: Enemy


@onready var orc_scene = preload("res://enemies/orc/orc_enemy.tscn")
@onready var boss_knight_scene = preload("res://enemies/knight_boss/knight_boss.tscn")
@onready var walls: TileMapLayer = %Walls
@onready var floor: TileMapLayer = %Floor
@onready var decor: TileMapLayer = %Decor
@onready var gate_open: Timer = %GateOpen
@onready var boss_agro_range: Area2D = %BossAgroRange


func generate(floor_size: Vector2i):
	boss_agro_range.set_deferred("monitoring", true)
	var room_grid: Dictionary[Vector2i, Dictionary] = {}
	gate_frame = 0
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
	boss_room = farthest_pos
	_spawn_boss(boss_room, Bosses.KNIGHT)
	
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
	_erase_rect(center, Vector2i(16, 16))
	var main_room_size := Vector2i(
		randi_range(6, CHUNK_SIZE.x-4),
		randi_range(6, CHUNK_SIZE.y-4)
	)
	if has_ladder:
		main_room_size = CHUNK_SIZE - Vector2i(2, 2)
	
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
	# main room
	_rect(center, main_room_size)
	
	# if boss room
	if has_ladder:
		_red_floor(center, main_room_size)
	elif center:
		var rando: float = randf()
		if rando < 0.8:
			_spawn_orc(center*24, main_room_size*24-Vector2i(24*3, 24*3), 0.15)
		else:
			_set_chest(center)


func _rect(pos: Vector2i, size: Vector2i):
	var wall_cells: Array[Vector2i] = []
	var floor_cells: Array[Vector2i] = []
	
	var room_corner: Vector2i = size/-2
	
	for x in range(0, size.x):
		for y in range(0, size.y):
			wall_cells.append(Vector2i(room_corner.x + pos.x + x, \
					room_corner.y + pos.y + y))
			if y != 0 and not _is_red(floor.get_cell_atlas_coords(Vector2i(room_corner.x + pos.x + x, \
						room_corner.y + pos.y + y))):
				floor_cells.append(Vector2i(room_corner.x + pos.x + x, \
						room_corner.y + pos.y + y))
				decor.set_cell(Vector2i(room_corner.x + pos.x + x, \
						room_corner.y + pos.y + y), 1, Vector2i(0, 2))
	
	walls.set_cells_terrain_connect(wall_cells, 0, 0, false)
	floor.set_cells_terrain_connect(floor_cells, 0, 0)


func _erase_rect(pos: Vector2i, size: Vector2i):
	var room_corner: Vector2i = size/-2
	
	for x in range(0, size.x):
		for y in range(0, size.y):
			walls.set_cell(Vector2i(room_corner.x + pos.x + x, \
					room_corner.y + pos.y + y), 1, Vector2i(0, 0))
			if y != 0 and not _is_red(floor.get_cell_atlas_coords(Vector2i(room_corner.x + pos.x + x, \
						room_corner.y + pos.y + y))):
				floor.set_cell(Vector2i(room_corner.x + pos.x + x, \
						room_corner.y + pos.y + y), 1, Vector2i(0, 0))

func _is_red(coords: Vector2i):
	if coords <= Vector2i(1, 6) and coords >= Vector2i(0, 1):
		return true
	return false


func _red_floor(pos: Vector2i, size: Vector2i):
	var floor_cells: Array[Vector2i] = []
	
	var room_corner: Vector2i = size/-2
	
	for x in range(0, size.x):
		for y in range(0, size.y):
			if y != 0:
				floor_cells.append(Vector2i(room_corner.x + pos.x + x, \
						room_corner.y + pos.y + y))
	
	floor.set_cells_terrain_connect(floor_cells, 0, 1)


func _spawn_orc(pos: Vector2, size: Vector2, frec: float):
	var room_corner: Vector2 = size/-2
	for x in range(0, size.x, 24):
		for y in range(24, size.y, 24):
			if randf() > frec:
				continue
			var orc_pos := Vector2(room_corner.x + pos.x + x, \
					room_corner.y + pos.y + y)
			var orc: OrcEnemy = orc_scene.instantiate()
			orc.global_position = orc_pos
			spawn_orc.emit(orc)
			

func _set_chest(coords: Vector2i):
	decor.set_cell(coords, 1, Vector2i(1, 0))


func _on_gate_open_timeout() -> void:
	if gate_frame == 0:
		gate_frame += 1
		if boss_room:
			spawn_gate(boss_room)
		gate_open.start()
	elif gate_frame == 1:
		gate_frame += 1
		if boss_room:
			spawn_gate(boss_room)


func close_room(chunk_pos: Vector2i, has_ladder: bool):
	_gen_chunk(chunk_pos, false, false, false, false, has_ladder)


func spawn_gate(chunk_pos: Vector2i):
	var main_room_size := CHUNK_SIZE - Vector2i(2, 2)
	var gate_pos = Vector2i(chunk_pos.x*16-4, chunk_pos.y*16 - main_room_size.y/2)
	decor.set_cell(
		gate_pos,
		1,
		gate_frames[gate_frame]
	)
	walls.set_cell(
		gate_pos,
		1,
		Vector2i(2, 0)
	)


func _spawn_boss(chunk_pos: Vector2, boss_type: Bosses):
	var boss_pos: Vector2 = Vector2(chunk_pos.x*16*24, chunk_pos.y*16*24)
	if boss_type == Bosses.KNIGHT:
		var knight = boss_knight_scene.instantiate()
		knight.global_position = boss_pos
		boss = knight
		add_child(knight)
	boss_agro_range.position = boss_pos


func _on_boss_agro_range_body_entered(body: Node2D) -> void:
	if body is Player:
		boss_agro.emit(body)
		_erase_rect(boss_room*16, Vector2i(256, 256))
		close_room(boss_room, true)
		boss_agro_range.set_deferred("monitoring", false)
