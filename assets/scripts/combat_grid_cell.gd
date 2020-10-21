extends Control

var id: int
var mouse_enter_response
var mouse_exit_response

func _ready():
	pass

func _notification(what):
	match what:
		NOTIFICATION_MOUSE_ENTER:
			on_mouse_enter()
		NOTIFICATION_MOUSE_EXIT:
			on_mouse_exit()

func on_mouse_enter():
	if is_instance_valid(mouse_enter_response) && mouse_enter_response.is_valid():
		mouse_enter_response.call_func(id)
	#print("Enter")
	
func on_mouse_exit():
	if is_instance_valid(mouse_exit_response) && mouse_exit_response.is_valid():
		mouse_exit_response.call_func(id)
	#print("Exit")
