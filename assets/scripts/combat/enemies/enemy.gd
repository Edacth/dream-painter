class_name Enemy

var name: String
var health: int

var combat_grid

func _ready():
	pass

func start_turn():
	print("Start enemy turn")
	for _i in range(0,3):
		place_attack()


func place_attack():
	var valid_placements = []
	for id in range(0, combat_grid.grid_size.x * combat_grid.grid_size.y):
		if (combat_grid.can_shape_fit("test", id, "enemy")):
			valid_placements.append(id)
	if valid_placements.size() == 0: return
	combat_grid.place_shape("test", valid_placements[randi() % valid_placements.size()], "enemy")


func take_damage(amount):
	health -= amount
