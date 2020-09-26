extends Node
class_name Interactable_Object

export(Texture) var texture
export(Texture) var highlighted_texture

func _ready():
	add_to_group("interactable_object", true)

func interact():
	print(name, " interact")

func reset_highlight():
	$Sprite.texture = texture

func highlight():
	$Sprite.texture = highlighted_texture
