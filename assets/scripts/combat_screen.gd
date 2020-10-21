extends Control

var current_turn: String

func _ready():
	$VBoxContainer/BottomPanel/ShapeBar.shape_select_response = funcref($VBoxContainer/BottomPanel/CombatGrid, "change_shape")
	connect_energy_label()
	connect_enemy_ai()
	current_turn = "player"

func connect_energy_label():
	$VBoxContainer/BottomPanel/CombatGrid.energy_label = $VBoxContainer/BottomPanel/EnergyBar/EnergyLabel
	$VBoxContainer/BottomPanel/EnergyBar/EnergyLabel.text = str($VBoxContainer/BottomPanel/CombatGrid.energy)

func end_player_turn():
	current_turn = "enemy"

func connect_enemy_ai():
	$EnemyAI.combat_grid = $VBoxContainer/BottomPanel/CombatGrid

func _input(event):
	if event.is_action_pressed("test"):
		$EnemyAI.place_attack()
