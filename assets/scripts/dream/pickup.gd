extends InteractableObject

signal picked_up

export(String) var item_id = ""


func _init():
	# init because ready isn't fast enough
	add_to_group("pickup", true)

func interact():
	emit_signal("picked_up", item_id)
	.interact()
	self.queue_free()
