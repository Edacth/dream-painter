extends Panel


func _ready():
	connect_shape_buttons()

func on_select_shape(shape_type: String):
	print(shape_type)

func connect_shape_buttons():
	var nodes = $VBoxContainer.get_children()
	for button in nodes:
		#connect("pressed", self, "on_select_shape")
		button.pressed_response = funcref(self, "on_select_shape")
