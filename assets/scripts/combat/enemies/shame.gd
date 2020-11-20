extends Enemy



func _init():
	name = "Shame"
	health = 15

func start_turn():
	print("Start enemy turn")
	for _i in range(0,5):
		.place_attack()
