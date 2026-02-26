extends Node2D
## Main logic script

@onready var room_scene = preload("res://main/rooms/room.tscn")
@onready var player_scene = preload("res://player/player.tscn")
@onready var dropped_item_scene = preload("res://items/dropped_item.tscn")
@onready var hud: Hud = %Hud
@onready var main_menu: MainMenu = %MainMenu

var player: Player

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
	add_child(dropped_item)


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
	room.generate(Vector2i(3, 3))
	
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
	orc.died.connect(_spawn_item)
