extends Control

onready var cell_node = preload("res://assets/scenes/combat_scenes/grid_cell.tscn")
onready var red_tint = preload("res://assets/textures/combat_screen/red_tint.png")
onready var blue_tint = preload("res://assets/textures/combat_screen/blue_tint.png")
onready var grey_tint = preload("res://assets/textures/combat_screen/grey_tint.png")
export var grid_size: Vector2 = Vector2(7,7)
var cursored_cell = 0
var selected_shape: String

func _ready():
	create_cells(grid_size)
	resize_cursor_cell()

func create_cells(size: Vector2):
	var grid = $GridContainer
	grid.columns = size.x
	for i in range(size.x * size.y):
		var new_cell = cell_node.instance()
		new_cell.id = i
		new_cell.mouse_enter_response = funcref(self, "move_cursor_cell_to_id")
		new_cell.name = "GridCell" + str(i)
		grid.add_child(new_cell)

func resize_cursor_cell():
	#var cell_size = $GridContainer.get_child(0).rect_size
	$CursorCell.rect_size.x = $GridContainer.rect_size.x / grid_size.x
	$CursorCell.rect_size.y = $GridContainer.rect_size.y / grid_size.y

func move_cursor_cell_to_id(id: int):
	cursored_cell = id
	$CursorCell.rect_position = get_node("GridContainer/GridCell" + str(id)).rect_position

func place_shape(shape_name: String):
	var shape: ShapeLibrary.CellShape = ShapeLibrary.get_shape(shape_name)
	for cell in shape.cells:
		#print(get_relative_cell_id(cursored_cell, cell.position))
		var place_position = get_relative_cell_id(cursored_cell, cell.position)
		if place_position != -1:
			place_cell(place_position, cell.type)

func place_cell(id, type):
	if !(id < 0 || id >= grid_size.x * grid_size.y):
		match type:
			0:
				get_node("GridContainer/GridCell" + str(id) + "/Tint").texture = red_tint
			1:
				get_node("GridContainer/GridCell" + str(id) + "/Tint").texture = blue_tint
			2:
				get_node("GridContainer/GridCell" + str(id) + "/Tint").texture = grey_tint

func get_relative_cell_id(start_id: int, offset: Vector2) -> int:
	var relative_cell_id: int = start_id
	# Prevent horizontal overflow
	var start_row = (start_id / int(grid_size.x))
	var offset_row = (int(start_id + offset.x) / int(grid_size.x))
	if (start_row == offset_row):
		relative_cell_id += (grid_size.x * offset.y) + (offset.x)
		return relative_cell_id
	# Not a valid cell
	return -1

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			#place_cell(cursored_cell, "sword")
			#place_shape("Test")
			place_shape("Shield")
