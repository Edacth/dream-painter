extends Control

class EquippedSlot:
	var shape: String
	var corresponding_node: Node
	
	func _init(_shape, _corresponding_node):
		shape = _shape
		corresponding_node = _corresponding_node
		set_to_shape(shape)


	func set_to_shape(_shape):
		shape = _shape
		corresponding_node.get_node("Label").text = shape


onready var equipped_panel: Node = $EquippedPanel
onready var equipped_shape_container: Node = $EquippedPanel/VSplitContainer/Panel/EquippedShapeContainer
onready var selection_panel: Node = $SelectionPanel
onready var shape_selection_slot_scene = load("res://assets/scenes/real_scenes/bedroom/shape_selection_slot.tscn")
onready var equipped_shape_slot_scene = load("res://assets/scenes/real_scenes/bedroom/equipped_shape_slot.tscn")
onready var equipped_slots = []
onready var deselected_style = preload("res://assets/ui/real/bedroom/equipped_shape_slot_deselected.tres")
onready var selected_style = preload("res://assets/ui/real/bedroom/equipped_shape_slot_selected.tres")
var currently_hovered_equipped_slot = -1
var selected_equipped_slot


func _ready() -> void:
	pass


func setup(inventory: Node):
	var _err = inventory.connect("shape_unlocked", self, "add_selection_slot")
	for i in range(3):
		add_equipped_slot(i)
	select_equipped_slot(0)
	#add_selection_slot("sword")
	#add_selection_slot("shield")


func add_equipped_slot(slot_index: int) -> void:
	var new_slot: Node = equipped_shape_slot_scene.instance()
	equipped_slots.append(EquippedSlot.new("Test" + str(equipped_slots.size()), new_slot))
	equipped_shape_container.add_child(new_slot)
	var _err = new_slot.connect("mouse_entered", self, "on_equipped_slot_mouse_entered", [slot_index])
	_err = new_slot.connect("mouse_exited", self, "on_equipped_slot_mouse_exited")
	set_equipped_slot(slot_index, "blank")


func add_selection_slot(shape) -> void:
	var new_slot = shape_selection_slot_scene.instance()
	new_slot.setup(shape, funcref(self, "on_selection_slot_clicked"))
	selection_panel.get_node("GridContainer").add_child(new_slot)


func on_equipped_slot_mouse_entered(slot_index: int):
	currently_hovered_equipped_slot = slot_index
	#print(equipped_slots[slot_index])


func on_equipped_slot_mouse_exited():
	currently_hovered_equipped_slot = -1


func on_selection_slot_clicked(shape: String):
	set_equipped_slot(selected_equipped_slot, shape)


func set_equipped_slot(slot_index: int, _shape: String):
	var file_to_check = File.new()
	var cell_shape = ShapeLibrary.get_player_shape(_shape)
	equipped_slots[slot_index].shape = _shape
	var corre_node = equipped_slots[slot_index].corresponding_node
	corre_node.get_node("Label").text = _shape
	var icon_path = cell_shape.icon_path
	#if file_to_check.file_exists(icon_path):
	corre_node.get_node("Icon").texture = load(icon_path)
	var preview_path = cell_shape.preview_path
	#if file_to_check.file_exists(preview_path):
	corre_node.get_node("Preview").texture = load(preview_path)


func select_equipped_slot(slot_index: int):
	#print("Selected: " + str(slot_index))
	selected_equipped_slot = slot_index
	for i in range(equipped_slots.size()):
		if i != currently_hovered_equipped_slot:
			equipped_slots[i].corresponding_node.add_stylebox_override("panel", deselected_style)
	equipped_slots[slot_index].corresponding_node.add_stylebox_override("panel", selected_style)


func get_equipped_shapes() -> Array:
	var equipped_shapes = []
	for slot in equipped_slots:
		equipped_shapes.append(slot.shape)
	return equipped_shapes


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event:
		if event.button_index == BUTTON_LEFT && event.pressed && currently_hovered_equipped_slot != -1:
			select_equipped_slot(currently_hovered_equipped_slot)
