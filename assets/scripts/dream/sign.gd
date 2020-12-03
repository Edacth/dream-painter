extends Interactable_Object

signal sign_interacted(message)
export var message: String = ""

func _init():
	# init because ready isn't fast enough
	add_to_group("sign", true)


func interact():
	emit_signal("sign_interacted", message)
