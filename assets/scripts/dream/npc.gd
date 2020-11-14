extends Interactable_Object

signal combat_started(enemy_name, enemy_health)
var npc_name: String = "Toast"

func _init():
	# init because ready isn't fast enough
	add_to_group("npc", true)

func interact():
	emit_signal("combat_started", npc_name, 3)
