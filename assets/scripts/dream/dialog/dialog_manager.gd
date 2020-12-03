extends Control

class Choice:
	var pid: int
	var og_text: String
	
	func _init(_pid: int, _og_text: String):
		pid = _pid
		og_text = _og_text

var dream_gui: Node
var dialog_box: Node
var dialog_label : RichTextLabel
var choice_container: HBoxContainer
const conversation_folder_path = "res://assets/conversations/"
var conversations = []
var active_convo: Conversation
var conversation_active: bool = false
var choice_label_scene = preload("res://assets/scenes/choice_label.tscn")
var active_choices = []
var selected_choice = -1
var set_player_input_blockage_func


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
			# This line is because yarn is dumb and starts its pid system at 1 rather than 0
			# It insterts an empty passage so I can use the [] operator to find passages based on pid
			convo.passages.append(Conversation.new())
			for passage in result["passages"]:
				var _passage = Passage.new()
				_passage.text = passage["text"].split("===", false, 1)[0]
				_passage.name = passage["name"]
				_passage.pid = passage["pid"]
				if "links" in passage:
					for link in passage["links"]:
						var _link: Passage.Link = Passage.Link.new()
						_link.pid = link["pid"]
						_passage.links.append(_link)
				if "tags" in passage:
					for tag in passage["tags"]:
						_passage.tags.append(tag)
				convo.passages.append(_passage)
			conversations.append(convo)


func request_convo(convo_name: String):
	conversation_active = true
	if dream_gui.get_node_or_null("DialogBox") == null:
		dream_gui.add_child(dialog_box)
	for convo in conversations:
		if convo.name == convo_name:
			active_convo = convo
			break
	display_passage(active_convo, active_convo.start_node)
	set_player_input_blockage_func.call_func(true)


func request_runtime_message(message: String):
	conversation_active = true
	dream_gui.add_child(dialog_box)
	var custom_convo = Conversation.new()
	custom_convo.passages.append(Passage.new())
	custom_convo.start_node = 1
	custom_convo.passages.append(Passage.new("Blah", message, 1, [], []))
	display_passage(custom_convo, custom_convo.start_node)
	set_player_input_blockage_func.call_func(true)


func display_passage(conversation, passage_id):
	dialog_label.bbcode_text = conversation.passages[passage_id].text
	reset_choices()
	var make_visible = conversation.passages[passage_id].tags.has("show_choice")
	set_up_choices(conversation, conversation.passages[passage_id].links, make_visible)


func set_up_choices(conversation, links: Array, make_visible: bool):
	var i = 0
	for link in links:
		active_choices.append(Choice.new(link.pid, conversation.passages[link.pid].name))
		selected_choice = 0
		if make_visible:
			var instance = choice_label_scene.instance()
			instance.name = "choice" + str(i)
			instance.get_node("HBoxContainer/Label").bbcode_text = format(conversation.passages[link.pid].name, "center")
			choice_container.add_child(instance, true)
			i += 1
	if make_visible:
		highlight_choice(selected_choice)


func end_convo():
	conversation_active = false
	dream_gui.remove_child(dialog_box)
	reset_choices()
	selected_choice = -1
	set_player_input_blockage_func.call_func(false)

func highlight_choice(choice_index: int):
	for i in range(active_choices.size()):
		if i == choice_index:
			#choice_container.get_child(i).get_node("Label").bbcode_text = format(format(active_choices[i].og_text, "i"), "center")
			choice_container.get_child(i).get_node("HBoxContainer/Label").bbcode_text = active_choices[i].og_text
			choice_container.get_child(i).get_node("HBoxContainer/Panel/TextureRect").set_modulate(Color(0, 0, 0))
		else:
			#choice_container.get_child(i).get_node("Label").bbcode_text = format(active_choices[i].og_text, "center")
			choice_container.get_child(i).get_node("HBoxContainer/Label").bbcode_text = active_choices[i].og_text
			choice_container.get_child(i).get_node("HBoxContainer/Panel/TextureRect").set_modulate(Color(0, 0, 0, 0))


func format(text: String, format_marker: String):
	return ("[" + format_marker + "]" + text + "[/" + format_marker + "]")


func reset_choices():
	active_choices.clear()
	for child in choice_container.get_children():
		child.queue_free()
		choice_container.remove_child(child)


func _input(event):
	if !conversation_active: return
	if event.is_action_pressed("interact"):
		if active_choices.size() == 0:
			end_convo()
		else:
			display_passage(active_convo, active_choices[selected_choice].pid)
		accept_event()
	elif event.is_action_pressed("left"):
		selected_choice -= 1
		if selected_choice < 0:
			selected_choice = active_choices.size() -1
		highlight_choice(selected_choice)
		accept_event()
	elif event.is_action_pressed("right"):
		selected_choice += 1
		if selected_choice > active_choices.size() -1:
			selected_choice = 0
		highlight_choice(selected_choice)
		accept_event()
