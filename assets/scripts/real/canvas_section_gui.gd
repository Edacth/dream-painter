extends Panel

signal combination_updated(color)

var active_color
var active_inspiration

onready var color_picker = preload("res://assets/scenes/color_picker.tscn")

func _ready():
	var _err = $ColorButton.connect("button_up", self, "show_color_picker")

func show_color_picker():
	$ColorButton.add_child(color_picker.instance())
	var _err = $ColorButton/ColorPicker.connect("color_picked", self, "update_color")

func update_color(color):
	active_color = color
	emit_signal("combination_updated", color)
