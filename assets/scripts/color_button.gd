extends TextureButton

signal picked(color)
export var color = ""

func _ready():
	var _err = connect("button_up", self, "pressed")

func pressed():
	emit_signal("picked", color)
