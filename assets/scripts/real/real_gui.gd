extends CanvasLayer

var dream_button_up_func

onready var easel_node = $Easel
onready var bedroom_node = $Bedroom
onready var shop_node = $Shop

func _ready():
	connect_navbar()
	connect_bedroom()
	switch_section("easel")

func switch_section(section):
	var node_to_add
	var nodes_to_remove = []
	match section:
		"easel":
			node_to_add = easel_node
			nodes_to_remove.append(bedroom_node)
			nodes_to_remove.append(shop_node)
		"inventory":
			print("inventory")
			
		"bedroom":
			print("bedroom")
			node_to_add = bedroom_node
			nodes_to_remove.append(easel_node)
			nodes_to_remove.append(shop_node)
		"shop":
			print("shop")
			node_to_add = shop_node
			nodes_to_remove.append(easel_node)
			nodes_to_remove.append(bedroom_node)


	if node_to_add.get_parent() == null:
		self.add_child(node_to_add)
	for node in nodes_to_remove:
		if node.get_parent() != null:
			self.remove_child(node)


func connect_navbar():
	var nodes = $NavBar/Panel/HBoxContainer.get_children()
	for node in nodes:
		node.connect("navbar_button_up", self, "switch_section")


func connect_bedroom():
	var _err = $Bedroom/Panel/DreamButton.connect("button_up", self, "relay_dream_button_up")


func relay_dream_button_up():
	if is_instance_valid(dream_button_up_func) && dream_button_up_func.is_valid():
		dream_button_up_func.call_func()
