extends Panel

var mouse_over = false
var shape: String
var select_func: FuncRef

func _ready() -> void:
	var _err = connect("mouse_entered", self, "on_mouse_entered")
	_err = connect("mouse_exited", self, "on_mouse_exited")


func setup(_shape: String):
	shape = _shape
	$Label.text = shape.capitalize()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if mouse_over:
			select_func.call_func()
			accept_event()


func on_mouse_entered():
	mouse_over = true


func on_mouse_exited():
	mouse_over = false
