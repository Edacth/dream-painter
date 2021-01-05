extends Control

onready var ShopCost = load("res://assets/scripts/real/shop_entry_gui.gd").ShopCost
var shop_entry_scene = preload("res://assets/scenes/real_scenes/shop/shop_entry.tscn")
onready var grid_container = get_node("GridContainer")
onready var max_entries = 12
var inventory_node: Inventory


func setup(_inventory_node):
	inventory_node = _inventory_node
	create_shop_entry("shield", ShopCost.new("kinship", 2), funcref(self, "unlock_shape"), "shield")
	create_shop_entry("down sword", ShopCost.new("kinship", 1), funcref(self, "unlock_shape"), "down_sword")
	create_shop_entry("error", ShopCost.new("kinship", 1), funcref(self, "unlock_shape"), "error")
	var _err = $KinshipButton.connect("button_up", inventory_node, "add_item", ["kinship", 1])


func create_shop_entry(entry_name, cost, result: FuncRef, shape_to_unlock):
	var new_entry = shop_entry_scene.instance()
	new_entry.setup(entry_name, cost, funcref(inventory_node, "remove_item"),
		funcref(inventory_node, "has_item"), result, shape_to_unlock)
	grid_container.add_child(new_entry)




func unlock_shape(shape):
	inventory_node.unlock_shape(shape)
