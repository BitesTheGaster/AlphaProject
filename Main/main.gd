extends Node2D
## Main logic script

@export var floor_sizes: Array[Vector2i] = [
	Vector2i(5, 5),
	Vector2i(7, 7),
	Vector2i(15, 15),
]

var player: Player
var boss: Enemy
var loot: Array[Item]
var _room: Room
var enemies: Array[Enemy] = []
var started: bool = false
var min_fps: float
var max_fps: float
var current_floor: int = 0

@onready var room_scene = preload("res://main/rooms/room.tscn")
@onready var player_scene = preload("res://player/player.tscn")
@onready var dropped_item_scene = preload("res://items/dropped_item.tscn")
@onready var hud: Hud = %Hud
@onready var main_menu: MainMenu = %MainMenu
@onready var spark_anim_timer: Timer = %SparkAnimTimer
@onready var spark: GPUParticles2D = %Spark
@onready var enemy_update: Timer = %EnemyUpdate

func _ready() -> void:
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE
	hud.hide()
	main_menu.start.pressed.connect(_start_game)


func _process(delta: float) -> void:
	if started:
		var current_fps = Engine.get_frames_per_second()
		min_fps = min(min_fps, current_fps)
		max_fps = max(max_fps, current_fps)
		hud.update_fps(current_fps, min_fps, max_fps)


func _on_player_open_inventory():
	hud.inventory_closed = false
	hud.inventory.show()
	hud.tooltip.show()


func _on_player_close_inventory():
	hud.inventory_closed = true
	hud.inventory.hide()
	hud.tooltip.hide()


func _spawn_item(pos: Vector2, item: Item):
	var dropped_item: DroppedItem = dropped_item_scene.instantiate()
	dropped_item.global_position = pos
	dropped_item.sprite_texture = item.texture
	dropped_item.name = item.item_name
	dropped_item.item = item
	dropped_item.player_entered.connect(_pickup_item)
	call_deferred("add_child", dropped_item)


func _pickup_item(dropped_item: DroppedItem, item: Item):
	var free_slot: int = GlobalInventory.inventory.get_free_slot()
	if free_slot != 0:
		GlobalInventory.inventory.items[free_slot] = item
		dropped_item.queue_free()
		hud.update_textures()


func _start_game():
	hud.inventory_closed = true
	
	main_menu.hide()
	hud.show()
	
	var room: Room = room_scene.instantiate()
	room.position = Vector2.ZERO
	add_child(room)
	room.spawn_orc.connect(_spawn_orc)
	room.decor.chest_opened.connect(_chest_opened)
	room.decor.new_floor.connect(_new_floor)
	room.boss_agro.connect(_on_boss_agro_range_body_entered)
	room.generate(floor_sizes[current_floor])
	boss = room.boss
	boss.died.connect(_on_boss_death)
	_room = room
	
	player = player_scene.instantiate()
	player.open_inventory.connect(_on_player_open_inventory)
	player.close_inventory.connect(_on_player_close_inventory)
	player.health_changed.connect(hud.on_player_health_changed)
	player.position = Vector2.ZERO
	player.hair_modulate = main_menu.hair.modulate
	player.shirt_modulate = main_menu.shirt.modulate
	player.pants_modulate = main_menu.pants.modulate
	add_child(player)
	
	hud.player = player
	started = true
	
	enemy_update.start()
	
	for child in get_children():
		if child is Enemy:
			enemies.append(child)
	print("Floor: " + str(current_floor) + " Enemies: " + str(len(enemies)) + \
			" Size: " + str(floor_sizes[current_floor]))

func _spawn_orc(orc: OrcEnemy):
	add_child(orc)
	orc.died.connect(_on_orc_died)


func _on_orc_died(global_pos: Vector2, loot_table_name: LootManager.Names):
	var orc_loot: Array[Item] = \
			LootManager.loot_tables[loot_table_name] \
			.get_loot(player.stats.luck)
	var count: int = 1
	for item in orc_loot:
		var pos: Vector2 = global_pos
		pos += 8*Vector2.from_angle(deg_to_rad(360.0/len(orc_loot)*count+90))
		_spawn_item(pos, item)
		count += 1


func _chest_opened(chest_coords: Vector2, tier: int):
	loot = LootManager.get_chest_loot(tier, player.stats.luck)
	spark_anim_timer.start()
	spark.position = chest_coords + Vector2(12, 12)
	if len(loot):
		spark.amount = len(loot)
		spark.emitting = true


func _on_spark_anim_timer_timeout() -> void:
	var count: int = 1
	for item in loot:
		var pos: Vector2 = spark.position
		pos += 16*Vector2.from_angle(deg_to_rad(360.0/len(loot)*count+90))
		_spawn_item(pos, item)
		count += 1


func _on_boss_agro_range_body_entered(body: Node2D) -> void:
	if body is Player and boss:
		boss.set_target(body)
		for child in get_children():
			if child is Enemy and not child == boss:
				child.queue_free()


func _on_boss_death(global_pos: Vector2, loot_table_name: LootManager.Names):
	var loot: Array[Item] = \
			LootManager.loot_tables[loot_table_name] \
			.get_loot(player.stats.luck)
	var count: int = 1
	for item in loot:
		var pos: Vector2 = global_pos
		pos += 8*Vector2.from_angle(deg_to_rad(360.0/len(loot)*count+90))
		_spawn_item(pos, item)
		count += 1
	_room.decor.show()
	_room.walls.show()
	_room.floor.show()
	_room.boss_border_collision.set_deferred("disabled", true)
	_room.boss_border_sprite.hide()
	_room.spawn_gate(_room.boss_room)
	_room.gate_open.start()


func _on_enemy_update_timeout() -> void:
	for child in enemies:
		if not child:
			continue
		if abs(child.position - player.position).x > 256*1.75 or \
				abs(child.position - player.position).y > 128*1.75:
			child.process_mode = Node.PROCESS_MODE_DISABLED
			child.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
			child.disabled = true
			child.nav_agent.avoidance_enabled = false
			child.hide()
		else:
			child.process_mode = Node.PROCESS_MODE_INHERIT
			child.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT
			child.disabled = false
			child.nav_agent.avoidance_enabled = true
			child.show()


func _new_floor():
	current_floor += 1
	
	if not current_floor < len(floor_sizes):
		player.take_damage(1488) # Temporary
		print("Floor " + str(current_floor) + " does not exist")
		return
	
	player.position = Vector2.ZERO
	_room.generate(floor_sizes[current_floor])
	while enemies:
		enemies.pop_back()
	print(len(enemies))
	for child in get_children():
		if child is Enemy:
			enemies.append(child)
	print("Floor: " + str(current_floor) + " Enemies: " + str(len(enemies)) + \
			" Size: " + str(floor_sizes[current_floor]))
	boss = _room.boss
	boss.died.connect(_on_boss_death)
