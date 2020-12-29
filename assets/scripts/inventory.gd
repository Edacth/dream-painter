extends Node2D
class_name Inventory

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

func add_item(item_name: String, amount: int) -> void:
	for slot in slots:
		if item_name == slot.name:
			slot.amount += amount
			emit_signal("inventory_updated", item_name, slot.amount)
			print(slot.amount)
			break


func has_item(item_name: String, amount: int) -> bool:
	for slot in slots:
		if item_name == slot.name:
			if slot.amount >= amount:
				return true
			break
	return false


func remove_item(item_name: String, amount: int) -> void:
	for slot in slots:
		if item_name == slot.name:
			slot.amount = clamp(slot.amount - amount, 0, 9223372036854775807)
			emit_signal("inventory_updated", item_name, slot.amount)
			break
