extends Node2D

var state = "real"
var real_root
var dream_root
var pigment_count = 0

func _ready():
	real_root = $RealWorld
	dream_root = $DreamWorld
	$DreamWorld/Player.terrain_map = $DreamWorld/TerrainTileMap
	var _err = $RealWorld/RealGUI/Debug/Panel/SwitchButton.connect("button_down", self, "switch_to_state", ["dream"])
	_err = $DreamWorld/DreamGUI/Debug/Panel/SwitchButton.connect("button_down", self, "switch_to_state", ["real"])
	_err = $DreamWorld.connect("generation_finished", self, "connect_pickup_signals")
	$RealWorld/RealGUI.dream_button_up_func = funcref(self, "enter_dream")
	connect_inv_gui_signals()
	switch_to_state(state)
	

func _unhandled_input(event):
	if event.is_action_pressed("switch_to_real"):
		switch_to_state("real")
	elif event.is_action_pressed("switch_to_dream"):
		switch_to_state("dream")
	
func switch_to_state(to_state):
	if to_state == "real":
		if real_root.get_parent() == null:
			self.add_child(real_root)
		self.remove_child(dream_root)
	elif to_state == "dream":
		if dream_root.get_parent() == null:
			self.add_child(dream_root)
		self.remove_child(real_root)
		
func connect_pickup_signals():
	var dream_root_children = dream_root.get_children()
	for obj in dream_root_children:
		if obj.is_in_group("pickup"):
			obj.connect("picked_up", self, "process_pickup")
			
func process_pickup(item_id):
	$Inventory.add_item(item_id, 1)
		
func connect_inv_gui_signals():
	var _err = $Inventory.connect("inventory_updated", $DreamWorld/DreamGUI/Inventory, "update_display")
	_err = $Inventory.connect("inventory_updated", $RealWorld/RealGUI/Inventory, "update_display")

func enter_dream():
	dream_root.generate_world()
	switch_to_state("dream")
