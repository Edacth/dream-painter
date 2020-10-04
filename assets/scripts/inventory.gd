extends Node2D

var slots = []

signal inventory_updated

class ItemSlot:
	var name
	var amount = 0
	
	func _init(_name):
		name = _name

func _ready():
	slots.append(ItemSlot.new("kinship"))
	slots.append(ItemSlot.new("fear"))

func add_item(item_name: String, amount):
	for slot in slots:
		if item_name == slot.name:
			slot.amount += amount
			emit_signal("inventory_updated", item_name, slot.amount)
			print(slot.amount)
			break
