extends Control

var id: int
var mouse_enter_response

func _ready():
	pass

func _notification(what):
	match what:
		NOTIFICATION_MOUSE_ENTER:
			on_hover()

func on_hover():
	if mouse_enter_response.is_valid():
		mouse_enter_response.call_func(id)
