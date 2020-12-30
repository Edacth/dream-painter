extends TextureButton

export var shape_type: String
var pressed_response: FuncRef


func _ready():
	var _err = connect("button_up", self, "on_press")


func setup(shape: String):
	shape_type = shape
	texture_normal = load(ShapeLibrary.get_player_shape(shape).icon_path)


func on_press():
	if is_instance_valid(pressed_response) && pressed_response.is_valid():
		pressed_response.call_func(shape_type)
