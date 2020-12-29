extends Panel

class ShopCost:
	var resource: String
	var amount: int
	
	func _init(_resource, _amount):
		resource = _resource
		amount = _amount

var cost: ShopCost
var buy_result_func: FuncRef
var exact_cost_func: FuncRef
var has_item_func: FuncRef
var shape_to_unlock


func _ready():
	var _err = $Button.connect("button_up", self, "attempt_buy")


func setup(entry_name, _cost: ShopCost, _exact_cost_func, _has_item_func, result, _shape_to_unlock = ""):
	$Label.text = entry_name
	cost = _cost
	$Button.text = cost.resource.capitalize() + str(cost.amount)
	buy_result_func = result
	shape_to_unlock = _shape_to_unlock
	exact_cost_func = _exact_cost_func
	has_item_func = _has_item_func


func attempt_buy():
	if has_item_func.call_func(cost.resource, cost.amount):
		buy_sucess()
	else:
		print("Not Enough")


func buy_sucess():
	exact_cost_func.call_func(cost.resource, cost.amount)
	buy_result_func.call_func(shape_to_unlock)
	$Button.disabled = true
