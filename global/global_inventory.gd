extends Node
## Global variables

var inventory: Inventory
var current_slot = 0


func _ready() -> void:
	inventory = Inventory.new()
