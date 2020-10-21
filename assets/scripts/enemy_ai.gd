extends Control

var combat_grid : CombatGrid

func _ready():
	pass

func start_turn():
	print("Start enemy turn")

func place_attack():
	combat_grid.place_shape("sword", 26)
