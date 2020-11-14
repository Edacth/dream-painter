extends Node2D

var state = "real"
var real_root
var dream_root
var combat_root
var pigment_count = 0

func _ready():
	real_root = $RealWorld
	dream_root = $DreamWorld
	combat_root = $CombatScreen
	$DreamWorld/Player.terrain_map = $DreamWorld/TerrainTileMap
	var _err = $RealWorld/RealGUI/Debug/Panel/SwitchButton.connect("button_down", self, "enter_dream")
	_err = $DreamWorld/DreamGUI/Debug/Panel/SwitchButton.connect("button_down", self, "switch_scene_root", ["real"])
	_err = $DreamWorld/Generator.connect("generation_finished", self, "connect_pickup_signals")
	_err = $DreamWorld/Generator.connect("generation_finished", self, "connect_npc_signals")
	$RealWorld/RealGUI.dream_button_up_func = funcref(self, "enter_dream")
	connect_inv_gui_signals()
	switch_scene_root(state)
	

func _unhandled_input(event):
	if event.is_action_pressed("switch_to_real"):
		switch_scene_root("real")
	elif event.is_action_pressed("switch_to_dream"):
		switch_scene_root("dream")
	
func switch_scene_root(to_state):
	var root_to_add
	var roots_to_remove = []
	if to_state == "real":
		root_to_add = real_root
		roots_to_remove.append(dream_root)
		roots_to_remove.append(combat_root)
	elif to_state == "dream":
		root_to_add = dream_root
		roots_to_remove.append(real_root)
		roots_to_remove.append(combat_root)
	elif to_state == "combat":
		root_to_add = combat_root
		roots_to_remove.append(real_root)
		roots_to_remove.append(dream_root)
		
	if root_to_add.get_parent() == null:
		self.add_child(root_to_add)
	for root in roots_to_remove:
		if root.get_parent() != null:
			self.remove_child(root)
		
func connect_pickup_signals():
	var dream_root_children = dream_root.get_children()
	for obj in dream_root_children:
		if obj.is_in_group("pickup"):
			obj.connect("picked_up", self, "process_pickup")

func connect_npc_signals():
	var dream_root_children = dream_root.get_children()
	for obj in dream_root_children:
		if obj.is_in_group("npc"):
			obj.connect("combat_started", self, "start_combat")

func process_pickup(item_id):
	$Inventory.add_item(item_id, 1)
		
func connect_inv_gui_signals():
	var _err = $Inventory.connect("inventory_updated", $DreamWorld/DreamGUI/Inventory, "update_display")
	_err = $Inventory.connect("inventory_updated", $RealWorld/RealGUI/Inventory, "update_display")

func enter_dream():
	dream_root.generate_world()
	switch_scene_root("dream")

func start_combat(enemy_name, enemy_health):
	combat_root.setup(enemy_name, enemy_health)
	switch_scene_root("combat")
