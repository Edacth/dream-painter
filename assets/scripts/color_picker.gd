extends Panel

signal color_picked(color)

func _ready():
	connect_buttons()

func relay_color(color):
	emit_signal("color_picked", color)
	self.queue_free()
	get_parent().remove_child(self)

func connect_buttons():
	var nodes = $GridContainer.get_children()
	for node in nodes:
		node.get_node("TextureButton").connect("picked", self, "relay_color")
