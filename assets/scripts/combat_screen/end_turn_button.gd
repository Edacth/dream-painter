extends TextureButton

var on_press_response

func _ready():
	var _err = connect("button_up", self, "on_press")

func on_press():
	if is_instance_valid(on_press_response) && on_press_response.is_valid():
		on_press_response.call_func()
