extends Button

signal navbar_button_up(section)

export var section: String

func _ready():
	var _err = connect("button_up", self, "relay_button_up")

func relay_button_up():
	emit_signal("navbar_button_up", section)
