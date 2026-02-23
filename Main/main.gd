extends Node2D
## Main logic script

@onready var player = %Player
@onready var hud = %Hud


func _ready() -> void:
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_HIDDEN
	player.open_inventory.connect(_on_player_open_inventory)
	player.close_inventory.connect(_on_player_close_inventory)


func _on_player_open_inventory():
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE
	hud.show()


func _on_player_close_inventory():
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_HIDDEN
	hud.hide()
