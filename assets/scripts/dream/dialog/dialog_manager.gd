extends Node2D

var dialog_box
const conversation_folder_path = "res://assets/conversations/"
var conversations = []

func read_conversations():
	var file_names = []
	var dir = Directory.new()
	dir.open(conversation_folder_path)
	dir.list_dir_begin(true, false)
	
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		file_names.append(file_name)
	dir.list_dir_end()
	for file_name in file_names:
		var convo: Conversation = Conversation.new()
		var file = File.new()
		file.open(conversation_folder_path + file_name, File.READ)
		var json = JSON.parse(file.get_as_text())
		var result = json.result
		# Make sure json is okay
		if json.error == OK && typeof(result) == TYPE_DICTIONARY:
			convo.name = result["name"]
			convo.start_node = result["startnode"]
			for passage in result["passages"]:
				var _passage = Passage.new()
				_passage.text = passage["text"]
				_passage.name = passage["name"]
				_passage.pid = passage["pid"]
				if "links" in passage:
					for link in passage["links"]:
						var _link: Passage.Link = Passage.Link.new()
						_link.pid = link["pid"]
						_passage.links.append(_link)
				convo.passages.append(_passage)
			conversations.append(convo)


func test():
	dialog_box.text = ""
