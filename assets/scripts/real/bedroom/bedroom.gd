extends Control

onready var equipped_panel: Node = $EquippedPanel
onready var selection_panel: Node = $SelectionPanel
onready var shape_selection_slot_scene = load("res://assets/scenes/real_scenes/bedroom/shape_selection_slot.tscn")

func _ready() -> void:
	pass


func setup(inventory: Node):
	var _err = inventory.connect("shape_unlocked", self, "add_selection_slot")


func add_selection_slot(shape) -> void:
	var new_slot = shape_selection_slot_scene.instance()
	new_slot.setup(shape)
	selection_panel.get_node("GridContainer").add_child(new_slot)
