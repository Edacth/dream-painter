extends MarginContainer


func _ready():
	pass

func update_display(item_name: String, amount: int):
	var path = "Panel/" + item_name
	get_node(path).text = item_name + ": " + str(amount)
