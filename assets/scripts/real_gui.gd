extends CanvasLayer

var dream_button_up_func

onready var easel_node = $Easel
onready var bedroom_node = $Bedroom

func _ready():
	connect_navbar()
	connect_bedroom()
	switch_section("easel")

func switch_section(section):
	match section:
		"easel":
			print("easel")
			if easel_node.get_parent() == null:
				self.add_child(easel_node)
			self.remove_child(bedroom_node)
		"inventory":
			print("inventory")
			
		"bedroom":
			print("bedroom")
			if bedroom_node.get_parent() == null:
				self.add_child(bedroom_node)
			self.remove_child(easel_node)

func connect_navbar():
	var nodes = $NavBar/Panel/HBoxContainer.get_children()
	for node in nodes:
		node.connect("navbar_button_up", self, "switch_section")

func connect_bedroom():
	var _err = $Bedroom/Panel/DreamButton.connect("button_up", self, "relay_dream_button_up")

func relay_dream_button_up():
	dream_button_up_func.call_func()
