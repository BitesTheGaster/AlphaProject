class_name Hud
extends CanvasLayer
##

var _item_sprites: Dictionary[int, Sprite2D]
var min_fps: float = 999
var max_fps: float = -1
var inventory_closed: bool = false

@onready var weapon_sprite: Sprite2D = %WeaponSprite
@onready var tooltip: Label = %Tooltip
@onready var item_slots: Sprite2D = %ItemSlots
@onready var player: Player
@onready var inventory: Sprite2D = %Inventory
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var fps_counter: Label = %FpsCounter


func _ready() -> void:
	update_textures()
	
	for child in item_slots.get_children():
		if child is Sprite2D:
			_item_sprites[int(child.name)] = child


func _process(delta: float) -> void:
	if inventory_closed:
		return
	
	if Input.is_action_just_pressed("Equip") and GlobalInventory.current_slot != 0:
		if GlobalInventory.current_slot <= 44 and \
				GlobalInventory.inventory.weapon != Weapons.EMPTY:
			if GlobalInventory.inventory.items[GlobalInventory.current_slot] is Weapon:
				var temp_weapon: Weapon = GlobalInventory.inventory.items[GlobalInventory.current_slot]
				GlobalInventory.inventory.items[GlobalInventory.current_slot] = \
						GlobalInventory.inventory.weapon
				GlobalInventory.inventory.weapon = temp_weapon
				GlobalInventory.inventory.weapon.equip(player)
			elif GlobalInventory.inventory.items[GlobalInventory.current_slot] is Potion:
				GlobalInventory.inventory.items[GlobalInventory.current_slot].use(player)
				GlobalInventory.inventory.items[GlobalInventory.current_slot] = \
						Items.EMPTY
		
		update_textures()
	
	if Input.is_action_just_pressed("Drop") and GlobalInventory.current_slot <= 44 \
			and GlobalInventory.current_slot >= 1:
		GlobalInventory.inventory.items[GlobalInventory.current_slot] = \
				Items.EMPTY
		
		update_textures()


func _unhandled_input(event: InputEvent) -> void:
	if inventory_closed:
		GlobalInventory.current_slot = 0
		return
	
	var mouse_pos: Vector2
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		GlobalInventory.current_slot = _get_item_slot(mouse_pos)
		tooltip.position = mouse_pos - Vector2(0, -32)
		if GlobalInventory.current_slot == 0:
			tooltip.text = ""
		elif GlobalInventory.current_slot <= 44:
			tooltip.text = GlobalInventory.inventory.items[GlobalInventory.current_slot].item_name
		elif GlobalInventory.current_slot == 45:
			tooltip.text = GlobalInventory.inventory.weapon.item_name


func _get_item_slot(mouse_pos: Vector2) -> int:
	# Base slots
	for sprite in item_slots.get_children():
		if sprite is Sprite2D:
			if mouse_pos.x < sprite.global_position.x + 28 and \
					mouse_pos.y < sprite.global_position.y + 28 and \
					mouse_pos.x > sprite.global_position.x - 28 and \
					mouse_pos.y > sprite.global_position.y - 28:
				return int(sprite.name)
	
	# Weapon slot
	if mouse_pos.x < weapon_sprite.global_position.x + 28 and \
			mouse_pos.y < weapon_sprite.global_position.y + 28 and \
			mouse_pos.x > weapon_sprite.global_position.x - 28 and \
			mouse_pos.y > weapon_sprite.global_position.y - 28:
		return 45
	
	# Spell slot
	# Not yet
	
	return 0


func update_textures():
	for child in item_slots.get_children():
		if child is Sprite2D:
			child.texture = GlobalInventory.inventory.items[int(child.name)].texture
	
	weapon_sprite.texture = GlobalInventory.inventory.weapon.texture


func on_player_health_changed(health: int):
	health_bar.value = health


func update_fps(current_fps: float, min_fps: float, max_fps: float):
	fps_counter.text = "current fps: " + str(current_fps) \
			+ "\nmin: " + str(min_fps) + "\nmax: " + str(max_fps)
