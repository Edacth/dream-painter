extends InteractableSign

func reset_highlight():
	$TextureRect.texture = texture

func highlight():
	$TextureRect.texture = highlighted_texture
