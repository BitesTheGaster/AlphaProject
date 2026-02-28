extends Node2D
## Main logic script

@onready var room_scene = preload("res://main/rooms/room.tscn")
@onready var player_scene = preload("res://player/player.tscn")
@onready var dropped_item_scene = preload("res://items/dropped_item.tscn")
@onready var hud: Hud = %Hud
@onready var main_menu: MainMenu = %MainMenu
@onready var spark_anim_timer: Timer = %SparkAnimTimer
@onready var spark: GPUParticles2D = %Spark

var player: Player
var loot: Array[Item]

func _ready() -> void:
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE
	hud.hide()
	main_menu.start.pressed.connect(_start_game)

func _on_player_open_inventory():
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE
	hud.inventory.show()
	hud.tooltip.show()


func _on_player_close_inventory():
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_HIDDEN
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
	var free_slot: int = Global.inventory.get_free_slot()
	if free_slot != 0:
		Global.inventory.items[free_slot] = item
		dropped_item.queue_free()
		hud.update_textures()


func _start_game():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	main_menu.hide()
	hud.show()
	
	var room: Room = room_scene.instantiate()
	room.position = Vector2.ZERO
	add_child(room)
	room.spawn_orc.connect(_spawn_orc)
	room.decor.chest_opened.connect(_chest_opened)
	room.generate(Vector2i(7, 7))
	
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
	spark.amount = len(loot)
	spark.emitting = true


func _on_spark_anim_timer_timeout() -> void:
	var count: int = 1
	for item in loot:
		var pos: Vector2 = spark.position
		pos += 16*Vector2.from_angle(deg_to_rad(360.0/len(loot)*count+90))
		_spawn_item(pos, item)
		count += 1
