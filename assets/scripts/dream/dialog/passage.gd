extends Object

class_name Passage

class Link:
	var pid: int

var name: String
var text: String
var pid: int
var links = []
var tags : Array = []

func _init(_name = "", _text = "", _pid = 1, _links = [], _tags = []):
	name = _name
	text = _text
	pid = _pid
	links = _links
	tags = _tags
