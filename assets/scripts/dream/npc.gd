extends Interactable_Object

signal combat_started(enemy_name, enemy_health, on_defeat_func)
var npc_name: String = "Toast"
var reconnect_dungeon_func: FuncRef

func _init():
	# init because ready isn't fast enough
	add_to_group("npc", true)

func interact():
	emit_signal("combat_started", npc_name, 3, funcref(self, "on_defeat"))

func on_defeat():
	var drop: Node = load("res://assets/scenes/dream_scenes/kinship.tscn").instance()
	get_parent().add_child(drop)
	drop.position = self.position
	if is_instance_valid(reconnect_dungeon_func) && reconnect_dungeon_func.is_valid():
		reconnect_dungeon_func.call_func()
	get_parent().remove_child(self)
	self.queue_free()
