extends Node
class_name Interactable_Object

export(Texture) var texture
export(Texture) var highlighted_texture
var within_range_of_player = false

func _ready():
	add_to_group("interactable_object", true)
	if get_node_or_null("InteractBox") != null:
		var _err = $InteractBox.connect("body_entered", self, "on_body_entered")
		_err = $InteractBox.connect("body_exited", self, "on_body_exited")
	else:
		print_debug(self.name + " does not have InteractBox")

func interact():
	print(name, " interact")

func reset_highlight():
	$Sprite.texture = texture

func highlight():
	$Sprite.texture = highlighted_texture

func on_body_entered(_body):
	#print(body.name)
	highlight()
	within_range_of_player = true
	
func on_body_exited(_body):
	reset_highlight()
	within_range_of_player = false
