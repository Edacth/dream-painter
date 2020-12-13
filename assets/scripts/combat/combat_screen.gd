extends Control

var combat_grid_node: Node
var current_turn: String
var enemy_defeated: bool = false
var switch_root_func: FuncRef
var dream_scene_enemy_defeat_func: FuncRef
var player_defeat_func: FuncRef
onready var defeat_panel_node = get_node("VBoxContainer/BottomPanel/CombatGrid/DefeatPanel") 


func _ready():
	print("COMBAT READY")
	combat_grid_node = $VBoxContainer/BottomPanel/CombatGrid
	combat_grid_node.get_player_health_func = funcref(self, "get_player_health")
	combat_grid_node.set_player_health_func = funcref(self, "set_player_health")
	$VBoxContainer/BottomPanel/ShapeBar.shape_select_response = funcref($VBoxContainer/BottomPanel/CombatGrid, "change_shape")
	connect_energy_label()
	connect_enemy_ai()
	connect_enemy_health_label()
	$VBoxContainer/BottomPanel/ToolBar/EndTurnButton.on_press_response = funcref(self, "end_player_turn")
	$VBoxContainer/BottomPanel/ToolBar/BreakButton.connect("button_down", $VBoxContainer/BottomPanel/CombatGrid, "select_break_tool")


func setup(enemy_type, enemy_defeat_func):
	set_player_health(get_player_health()) # Lol this line
	combat_grid_node.remove_child(defeat_panel_node)
	$EnemyAI.setup_enemy(enemy_type)
	dream_scene_enemy_defeat_func = enemy_defeat_func
	current_turn = "enemy"
	enemy_defeated = false
	$VBoxContainer/BottomPanel/CombatGrid.clear_all_cells()
	$EnemyAI.start_turn()


func end_combat():
	if is_instance_valid(switch_root_func) && switch_root_func.is_valid():
		switch_root_func.call_func()
	print("END COMBAT")


func on_enemy_defeat():
	enemy_defeated = true
	dream_scene_enemy_defeat_func.call_func()


func connect_energy_label():
	$VBoxContainer/BottomPanel/CombatGrid.player_energy_label = $VBoxContainer/BottomPanel/PlayerEnergy
	$VBoxContainer/BottomPanel/PlayerEnergy.text = str($VBoxContainer/BottomPanel/CombatGrid.energy)
	
	
func connect_enemy_health_label():
	$EnemyAI.health_label = $VBoxContainer/TopPanel/EnemyHealth
	$VBoxContainer/BottomPanel/CombatGrid.enemy_take_damage_func = funcref($EnemyAI, "take_damage")


func end_player_turn():
	if current_turn == "player":
		current_turn = "enemy"
		$VBoxContainer/BottomPanel/CombatGrid.process_board_damage()
		$VBoxContainer/BottomPanel/CombatGrid.clear_temp_cells()
		if enemy_defeated == false:
			$EnemyAI.start_turn()
		else:
			end_combat()


func end_enemy_turn():
	if current_turn == "enemy":
		current_turn = "player"
		$VBoxContainer/BottomPanel/CombatGrid.energy = 3
		$VBoxContainer/BottomPanel/CombatGrid.player_energy_label.text = "Energy " + str(3)


func connect_enemy_ai():
	$EnemyAI.combat_grid = $VBoxContainer/BottomPanel/CombatGrid
	$EnemyAI.end_turn_repsonse = funcref(self, "end_enemy_turn")
	$EnemyAI.defeat_func = funcref(self, "on_enemy_defeat")
	$EnemyAI.name_label = $VBoxContainer/TopPanel/EnemyName


func get_player_health():
	return $Player.health


func set_player_health(amount):
	$Player.health = amount
	$VBoxContainer/BottomPanel/PlayerHealth.text = "Health " + str($Player.health)
	if $Player.health <= 0:
		combat_grid_node.add_child(defeat_panel_node)


func _input(event):
	if event is InputEventMouseButton && get_player_health() <= 0:
		player_defeat_func.call_func()
