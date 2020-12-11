extends Control

class_name CombatGrid

onready var cell_node = preload("res://assets/scenes/combat_scenes/grid_cell.tscn")
onready var red_tint = preload("res://assets/textures/combat_screen/red_tint.png")
onready var blue_tint = preload("res://assets/textures/combat_screen/blue_tint.png")
onready var grey_tint = preload("res://assets/textures/combat_screen/grey_tint.png")
onready var cursored_cell_texture = preload("res://assets/textures/combat_screen/cursored_cell.png")
onready var e_attack_tex = preload("res://assets/textures/combat_screen/weapons/enemy_attack.png")
export var grid_size: Vector2 = Vector2(7,7)
var cursored_cell = -1
var grid_cells = []
var selected_shape: String
onready var energy: int = 3
onready var health = 1
var player_energy_label
var player_health_label
var enemy_take_damage_func
var player_defeat_func
var selected_tool: String

func _ready():
	create_cells(grid_size)
	resize_cursor_cell()


func create_cells(size: Vector2):
	var grid = $GridContainer
	grid.columns = size.x
	for i in range(size.x * size.y):
		var new_cell = cell_node.instance()
		new_cell.id = i
		new_cell.mouse_enter_response = funcref(self, "set_cursor_cell")
		new_cell.mouse_exit_response = funcref(self, "clear_cursor_cell")
		new_cell.name = "GridCell" + str(i)
		new_cell.type = -1
		new_cell.enemy_type = -1
		grid.add_child(new_cell)
		grid_cells.append(new_cell)


func resize_cursor_cell():
	#var cell_size = $GridContainer.get_child(0).rect_size
	$CursorCell.rect_size.x = $GridContainer.rect_size.x / grid_size.x
	$CursorCell.rect_size.y = $GridContainer.rect_size.y / grid_size.y

func set_cursor_cell(id: int):
	cursored_cell = id
	get_grid_cell(id).get_node("Cursor").texture = cursored_cell_texture


func clear_cursor_cell(id: int):
	cursored_cell = -1
	get_grid_cell(id).get_node("Cursor").texture = null


func get_grid_cell(id: int):
	if !(id < 0 || id >= grid_size.x * grid_size.y):
		return grid_cells[id]


func place_shape(shape_name: String, placement_id: int, user: String):
	var shape: ShapeLibrary.CellShape
	if (user == "player"):
		shape = ShapeLibrary.get_player_shape(shape_name)
	elif (user == "enemy"):
		shape = ShapeLibrary.get_enemy_shape(shape_name)
	if shape == null: return
	
	for cell in shape.cells:
		var place_position = get_relative_cell_id(placement_id, cell.position)
		if place_position != -1:
			place_cell(cell.type, place_position, user)


func place_cell(type: int, id, user: String):
	if !(id < 0 || id >= grid_size.x * grid_size.y):
		var cell = get_grid_cell(id)
		#var texture_rect_name = user.capitalize() + "_Layer"
		match type:
			ShapeLibrary.CellType.EMPTY:
				cell.get_node("Player_Layer").texture = null
				cell.type = type
			ShapeLibrary.CellType.P_NEUTRAL:
				cell.get_node("Player_Layer").texture = grey_tint
				cell.type = type
			ShapeLibrary.CellType.P_DAMAGE:
				cell.get_node("Player_Layer").texture = red_tint
				cell.type = type
			ShapeLibrary.CellType.P_BLOCK:
				cell.get_node("Player_Layer").texture = blue_tint
				cell.type = type
			ShapeLibrary.CellType.E_DAMAGE:
				cell.get_node("Enemy_Layer").texture = e_attack_tex
				cell.get_node("Enemy_Layer").modulate = Color(1, 0, 0)
				cell.enemy_type = type


func get_relative_cell_id(start_id: int, offset: Vector2) -> int:
	var relative_cell_id: int = start_id
	# Prevent horizontal overflow
	var start_row = (start_id / int(grid_size.x))
	var offset_row = (int(start_id + offset.x) / int(grid_size.x))
	if (start_row == offset_row):
		relative_cell_id += (grid_size.x * offset.y) + (offset.x)
		if (relative_cell_id < 0 || relative_cell_id >= grid_size.x * grid_size.y):
			# Outside the top or bottom bounds
			return -1
		return relative_cell_id
	# Not a valid cell
	return -1


func change_shape(new_shape: String):
	selected_tool = "place"
	selected_shape = new_shape


func select_break_tool():
	selected_tool = "break"


func can_shape_fit(shape_to_fit: String, placement_id: int, user: String) -> bool:
	# Accomodate for both player and enemy shapes
	var shape
	if (user == "player"):
		shape = ShapeLibrary.get_player_shape(shape_to_fit)
	elif (user == "enemy"):
		shape = ShapeLibrary.get_enemy_shape(shape_to_fit)
	else:
		return false
	
	# Do the test
	if shape == null: return false
	var can_fit = true
	for shape_cell in shape.cells:
		var cell_position = get_relative_cell_id(placement_id, shape_cell.position)
		if cell_position == -1:
			can_fit = false
			break
		
		# Accomodate for both player and enemy shapes
		var grid_cell = get_grid_cell(cell_position)
		if (user == "player"):
			if (grid_cell.type != -1):
				can_fit = false
		if (user == "enemy"):
			if (grid_cell.enemy_type != -1 || grid_cell.type == ShapeLibrary.CellType.P_NEUTRAL):
				can_fit = false
	return can_fit


func process_board_damage():
	var player_damage = 0
	var enemy_damage = 0
	for id in range(0, grid_size.x * grid_size.y):
		var grid_cell = get_grid_cell(id)
		if (grid_cell.type == ShapeLibrary.CellType.P_DAMAGE):
			if (grid_cell.enemy_type == ShapeLibrary.CellType.E_DAMAGE):
				player_damage += 0.5
			else:
				player_damage += 1
		
		if (grid_cell.enemy_type == ShapeLibrary.CellType.E_DAMAGE):
			if (grid_cell.type == ShapeLibrary.CellType.P_BLOCK):
				enemy_damage += 0
			elif (grid_cell.type == ShapeLibrary.CellType.P_DAMAGE):
				enemy_damage += 0.5
			else:
				enemy_damage += 1
	print("The player dealt " + str(player_damage) + " damage")
	if is_instance_valid(enemy_take_damage_func) && enemy_take_damage_func.is_valid():
		enemy_take_damage_func.call_func(player_damage)
	print("The enemy dealt " + str(enemy_damage) + " damage")
	health -= enemy_damage
	player_health_label.text = "Health " + str(health)
	
	
func clear_temp_cells():
	for id in range(0, grid_size.x * grid_size.y):
		var grid_cell = get_grid_cell(id)
		if (grid_cell.type != ShapeLibrary.CellType.P_NEUTRAL):
			grid_cell.get_node("Player_Layer").texture = null
			grid_cell.type = -1
		grid_cell.get_node("Enemy_Layer").texture = null
		grid_cell.enemy_type = -1


func clear_all_cells():
	for id in range(0, grid_size.x * grid_size.y):
		var grid_cell = get_grid_cell(id)
		grid_cell.get_node("Player_Layer").texture = null
		grid_cell.type = -1
		grid_cell.get_node("Enemy_Layer").texture = null
		grid_cell.enemy_type = -1


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed && cursored_cell != -1:
			if selected_tool == "place" && energy > 0 && can_shape_fit(selected_shape, cursored_cell, "player"):
				place_shape(selected_shape, cursored_cell, "player")
				energy -= 1
				player_energy_label.text = "Energy " + str(energy)
			elif selected_tool == "break" && energy > 0 &&  get_grid_cell(cursored_cell).type != ShapeLibrary.CellType.EMPTY:
				place_cell(ShapeLibrary.CellType.EMPTY, cursored_cell, "player")
				energy -= 1
				player_energy_label.text = "Energy " + str(energy)
