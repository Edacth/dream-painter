extends Control

var enemy_name: String = ""

var enemy
var combat_grid
var end_turn_repsonse
var name_label
var health_label
var defeat_func: FuncRef

func _ready():
	pass

func setup_enemy(enemy_type: String):
	var path_to_script = "res://assets/scripts/combat/enemies/" + enemy_type + ".gd"
	enemy = load(path_to_script).new()
	enemy.combat_grid = combat_grid
	name_label.text = enemy.name
	health_label.text = "Health " + str(enemy.health)
	

func start_turn():
	enemy.start_turn()
	if is_instance_valid(end_turn_repsonse) && end_turn_repsonse.is_valid():
		end_turn_repsonse.call_func()


func take_damage(amount):
	enemy.take_damage(amount)
	health_label.text = "Health " + str(enemy.health)
	if enemy.health <= 0 && is_instance_valid(defeat_func) && defeat_func.is_valid():
		defeat_func.call_func()


func set_health(amount):
	enemy.health = amount
	health_label.text = "Health " + str(enemy.health)
