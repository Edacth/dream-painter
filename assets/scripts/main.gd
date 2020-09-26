extends Node2D

var state = "dream"
var real_root
var dream_root
var pigment_count = 0

func _ready():
	real_root = $RealWorld
	dream_root = $DreamWorld
	connect_pickup_signals()
	$RealWorld/CanvasLayer/MarginContainer/Panel/SwitchButton.connect("button_down", self, "switch_to_state", ["dream"])
	$DreamWorld/CanvasLayer/MarginContainer/Panel/SwitchButton.connect("button_down", self, "switch_to_state", ["real"])
	switch_to_state(state)
	

func _unhandled_input(event):
	if event.is_action_pressed("switch_to_real"):
		switch_to_state("real")
	elif event.is_action_pressed("switch_to_dream"):
		switch_to_state("dream")
	
func switch_to_state(to_state):
	if to_state == "real":
		self.add_child(real_root)
		self.remove_child(dream_root)
	elif to_state == "dream":
		self.add_child(dream_root)
		self.remove_child(real_root)
		
func connect_pickup_signals():
	var dream_root_children = dream_root.get_children()
	for obj in dream_root_children:
		if obj.is_in_group("pickup"):
			obj.connect("picked_up", self, "process_pickup")
			
func process_pickup(item_id):
	if item_id == "orange_pigment":
		pigment_count += 1
		print("LOL")
