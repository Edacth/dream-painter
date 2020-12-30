extends Panel

onready var shape_button_scene = load("res://assets/ui/combat/shape_bar_button.tscn")
var shape_select_response

func setup(shapes: Array):
	for shape in shapes:
		if shape == "blank": continue
		var new_button = shape_button_scene.instance()
		new_button.setup(shape)
		new_button.pressed_response = funcref(self, "on_select_shape")
		$VBoxContainer.add_child(new_button)


func on_select_shape(shape_type: String):
	shape_select_response.call_func(shape_type)
