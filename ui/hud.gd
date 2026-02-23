class_name Hud
extends CanvasLayer
##

var _current_slot = 0
var _item_sprites: Dictionary[int, Sprite2D]
var inventory: Inventory = Inventory.new()

@onready var weapon_sprite: Sprite2D = %WeaponSprite
@onready var tooltip: Label = %Tooltip
@onready var item_slots: Sprite2D = %ItemSlots
@onready var player: Player = %Player


func _ready() -> void:
	_update_textures()
	
	for child in item_slots.get_children():
		if child is Sprite2D:
			_item_sprites[int(child.name)] = child


func _process(delta: float) -> void:
	if Input.mouse_mode == Input.MouseMode.MOUSE_MODE_HIDDEN:
		return
	
	if Input.is_action_just_pressed("Equip") and _current_slot != 0:
		if _current_slot <= 44 and \
				inventory.weapon != Weapon.new():
			if inventory.items[_current_slot] is Weapon:
				var temp_weapon: Weapon = inventory.items[_current_slot]
				inventory.items[_current_slot] = inventory.weapon
				inventory.weapon = temp_weapon
				inventory.weapon.equip(player)
		
		_update_textures()
	
	if Input.is_action_just_pressed("Drop") and _current_slot <= 44 \
			and _current_slot >= 1:
		inventory.items[_current_slot] = Item.new()
		
		_update_textures()


func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MouseMode.MOUSE_MODE_HIDDEN:
		_current_slot = 0
		return
	
	var mouse_pos: Vector2
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		tooltip.position = mouse_pos - Vector2(0, -32)
		if _current_slot == 0:
			tooltip.text = ""
		elif _current_slot <= 44:
			tooltip.text = inventory.items[_current_slot].item_name
		elif _current_slot == 45:
			tooltip.text = inventory.weapon.item_name
		
		_current_slot = _get_item_slot(mouse_pos)


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


func _update_textures():
	for child in item_slots.get_children():
		if child is Sprite2D:
			child.texture = inventory.items[int(child.name)].texture
	
	weapon_sprite.texture = inventory.weapon.texture
