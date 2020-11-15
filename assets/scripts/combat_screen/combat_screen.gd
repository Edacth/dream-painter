extends Control

var current_turn: String
var enemy_defeated: bool = false
var switch_root_func: FuncRef
var dream_scene_enemy_defeat_func: FuncRef

func _ready():
	print("COMBAT READY")
	$VBoxContainer/BottomPanel/ShapeBar.shape_select_response = funcref($VBoxContainer/BottomPanel/CombatGrid, "change_shape")
	connect_energy_label()
	connect_enemy_ai()
	connect_enemy_health_label()
	connect_player_health_label()
	$VBoxContainer/BottomPanel/EnergyBar/EndTurnButton.on_press_response = funcref(self, "end_player_turn")


func setup(enemy_name, enemy_health, enemy_defeat_func):
	$VBoxContainer/TopPanel/EnemyName.text = enemy_name
	$EnemyAI.set_health(enemy_health)
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
	$VBoxContainer/BottomPanel/CombatGrid.energy_label = $VBoxContainer/BottomPanel/EnergyBar/EnergyLabel
	$VBoxContainer/BottomPanel/EnergyBar/EnergyLabel.text = str($VBoxContainer/BottomPanel/CombatGrid.energy)
	
	
func connect_enemy_health_label():
	$EnemyAI.health_label = $VBoxContainer/TopPanel/EnemyHealth
	$VBoxContainer/TopPanel/EnemyHealth.text = "Health " + str($EnemyAI.health)
	$VBoxContainer/BottomPanel/CombatGrid.enemy_take_damage_func = funcref($EnemyAI, "take_damage")
	
	
func connect_player_health_label():
	$VBoxContainer/BottomPanel/CombatGrid.player_health_label = $VBoxContainer/BottomPanel/PlayerHealth
	$VBoxContainer/BottomPanel/PlayerHealth.text = "Health " + str($VBoxContainer/BottomPanel/CombatGrid.health)


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
		$VBoxContainer/BottomPanel/CombatGrid.energy_label.text = "Energy\n" + str(3)

func connect_enemy_ai():
	$EnemyAI.combat_grid = $VBoxContainer/BottomPanel/CombatGrid
	$EnemyAI.end_turn_repsonse = funcref(self, "end_enemy_turn")
	$EnemyAI.defeat_func = funcref(self, "on_enemy_defeat")

func _input(event):
	if event.is_action_pressed("test"):
		$EnemyAI.place_attack()
