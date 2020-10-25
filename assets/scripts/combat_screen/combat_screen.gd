extends Control

var current_turn: String

func _ready():
	$VBoxContainer/BottomPanel/ShapeBar.shape_select_response = funcref($VBoxContainer/BottomPanel/CombatGrid, "change_shape")
	connect_energy_label()
	connect_enemy_ai()
	connect_enemy_health_label()
	connect_player_health_label()
	current_turn = "enemy"
	$VBoxContainer/BottomPanel/EnergyBar/EndTurnButton.on_press_response = funcref(self, "end_player_turn")
	$EnemyAI.start_turn()

func connect_energy_label():
	$VBoxContainer/BottomPanel/CombatGrid.energy_label = $VBoxContainer/BottomPanel/EnergyBar/EnergyLabel
	$VBoxContainer/BottomPanel/EnergyBar/EnergyLabel.text = str($VBoxContainer/BottomPanel/CombatGrid.energy)
	
	
func connect_enemy_health_label():
	$VBoxContainer/BottomPanel/CombatGrid.enemy_health_label = $VBoxContainer/TopPanel/EnemyHealth
	$VBoxContainer/TopPanel/EnemyHealth.text = "Health " + str($EnemyAI.health)
	
func connect_player_health_label():
	$VBoxContainer/BottomPanel/CombatGrid.player_health_label = $VBoxContainer/BottomPanel/PlayerHealth
	$VBoxContainer/BottomPanel/PlayerHealth.text = "Health " + str($VBoxContainer/BottomPanel/CombatGrid.health)

func end_player_turn():
	if current_turn == "player":
		current_turn = "enemy"
		$VBoxContainer/BottomPanel/CombatGrid.process_board_damage()
		$VBoxContainer/BottomPanel/CombatGrid.clear_temp_cells()
		$EnemyAI.start_turn()
		
func end_enemy_turn():
	if current_turn == "enemy":
		current_turn = "player"
		$VBoxContainer/BottomPanel/CombatGrid.energy = 3
		$VBoxContainer/BottomPanel/CombatGrid.energy_label.text = str(3)

func connect_enemy_ai():
	$EnemyAI.combat_grid = $VBoxContainer/BottomPanel/CombatGrid
	$EnemyAI.end_turn_repsonse = funcref(self, "end_enemy_turn")

func _input(event):
	if event.is_action_pressed("test"):
		$EnemyAI.place_attack()
