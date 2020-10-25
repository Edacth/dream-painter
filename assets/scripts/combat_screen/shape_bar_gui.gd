extends Panel

var shape_select_response

func _ready():
	connect_shape_buttons()

func on_select_shape(shape_type: String):
	shape_select_response.call_func(shape_type)

func connect_shape_buttons():
	var nodes = $VBoxContainer.get_children()
	if nodes == null: return
	for button in nodes:
		button.pressed_response = funcref(self, "on_select_shape")
