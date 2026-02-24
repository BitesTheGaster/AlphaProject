extends Node2D
## Main logic script

@onready var dropped_item_scene = preload("res://items/dropped_item.tscn")
@onready var player = %Player
@onready var hud = %Hud


func _ready() -> void:
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_HIDDEN
	
	player.open_inventory.connect(_on_player_open_inventory)
	player.close_inventory.connect(_on_player_close_inventory)
	player.health_changed.connect(hud.on_player_health_changed)
	
	_spawn_item(Vector2(256, 0), preload("res://resources/items/weapons/fire_sword.tres"))
	for child in get_children():
		if child is Enemy:
			child.died.connect(_spawn_item)

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
