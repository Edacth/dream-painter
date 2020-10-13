extends Control

onready var cell_node = load("res://assets/scenes/combat_scenes/grid_cell.tscn")
onready var sword_texture = load("res://assets/textures/combat_screen/sword_cell.png")
export var grid_size: Vector2 = Vector2(7,7)
var cursored_cell

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
		print(get_relative_cell_id(cursored_cell, cell.position))

func place_cell(id, type):
	get_node("GridContainer/GridCell" + str(id) + "/Texture").texture = sword_texture

func get_relative_cell_id(start_id: int, offset: Vector2) -> int:
	var relative_cell_id: int = start_id
	relative_cell_id += grid_size.x * offset.y
	return relative_cell_id

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			#place_cell(cursored_cell, "sword")
			place_shape("Test")
