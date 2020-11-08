extends Control

var health = 15
var combat_grid : CombatGrid
var end_turn_repsonse
var health_label

func _ready():
	pass

func start_turn():
	print("Start enemy turn")
	for i in range(0,3):
		place_attack()
	if is_instance_valid(end_turn_repsonse) && end_turn_repsonse.is_valid():
		end_turn_repsonse.call_func()

func place_attack():
	var valid_placements = []
	for id in range(0, combat_grid.grid_size.x * combat_grid.grid_size.y):
		if (combat_grid.can_shape_fit("test", id, "enemy")):
			valid_placements.append(id)
	if valid_placements.size() == 0: return
	combat_grid.place_shape("test", valid_placements[randi() % valid_placements.size()], "enemy")

func take_damage(amount):
	health -= amount
	health_label.text = "Health " + str(health)
