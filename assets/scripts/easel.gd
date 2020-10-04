extends HBoxContainer


func _ready():
	connect_GUI_sections()

func set_combination(color: String, section: int):
	var sectionTexture = $Canvas/TextureSections.get_node("SectionTexture"+str(section))
	sectionTexture.set_modulate(ColorCaster.cast_dict[color])

func connect_GUI_sections():
	var nodes = $GUISections.get_children()
	var index = 0
	for node in nodes:
		node.connect("combination_updated", self, "set_combination", [index])
		index += 1
