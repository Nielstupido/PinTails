extends Node

var file_name = "%s://Scenes/Globals/Settings/keybinding.dict" % ("user" if OS.has_feature("standalone") else "res")
var file_name_default = "%s://Scenes/Globals/Settings/default_keys.dict" % ("user" if OS.has_feature("standalone") else "res")

var setting_key = false
var keys_default : Dictionary

enum EventType {
	KEY,
	KEY_PHYSICAL,
	MOUSE_BUTTON,
}

var event_prefixes = [
	"key", # KEY
	"pkey", # KEY_PHYSICAL
	"mouse", # MOUSE_BUTTON
]


func _ready():
	load_keys()
# leftovers from tutorial version
#	get_child(0).visible = false
#	pause_mode = Node.PAUSE_MODE_PROCESS


func gen_dict_from_input_map() -> Dictionary:
	var actions = InputMap.get_actions()
	var result = Dictionary()
	for _action in actions:
		var action : String = _action as String
		# ignore built in ui actions
		if not action.begins_with("ui_"):
			result[action] = Array()
			for event in InputMap.action_get_events(action):
				result[action].push_back(event_to_str(event))
	return result


# We'll use this when the game loads
func load_keys():
	if(FileAccess.file_exists(file_name)):
		var raw = FileAccess.open(file_name, FileAccess.READ)
		var file_str = raw.get_as_text()
		raw.close()
		var data = str_to_var(file_str)
		if(typeof(data) == TYPE_DICTIONARY):
			setup_keys(data)
		else:
			printerr("corrupted data!")
	else:
		#NoFile, so lets save the default keys now
		save_keys(false)
		call_deferred("save_default_keys", true)
	
	var raw = FileAccess.open(file_name_default, FileAccess.READ)
	var file_str = raw.get_as_text()
	raw.close()
	var data = str_to_var(file_str)
	if(typeof(data) == TYPE_DICTIONARY):
		keys_default = data
	else:
		printerr("corrupted data!")


func setup_keys(key_dict : Dictionary):
	for action in key_dict.keys():
#		for j in get_tree().get_nodes_in_group("button_keys"):
#			if(j.action_name == i):
#				j.text = OS.get_keycode_string(key_dict[i])
		var has_invalid : bool = false
		var events = Array()
		for event_str in key_dict[action]:
			var event = str_to_event(event_str)
			if event:
				events.push_back(event)
			else:
				has_invalid = true
		if not has_invalid:
			InputMap.action_erase_events(action)
		for event in events:
			InputMap.action_add_event(action, event)


func event_to_str(event : InputEvent) -> String:
	if event is InputEventKey:
		var ev_type = EventType.KEY
		var keycode = event.keycode
		if event.keycode == 0:
			ev_type = EventType.KEY_PHYSICAL
			keycode = event.physical_keycode
		return "%s(%s)" % [event_prefixes[ev_type], OS.get_keycode_string(keycode)]
	elif event is InputEventMouseButton:
		var ev_type = EventType.MOUSE_BUTTON
		var keycode = event.get_button_index() 
		return "%s(%s)" % [event_prefixes[ev_type], keycode]
	else:
		print(var_to_str(event))
	return "?"


func str_to_event(string : String) -> InputEvent:
	string = string.strip_edges()
	for ev_type in event_prefixes.size():
		if string.begins_with(event_prefixes[ev_type]):
			string = string.trim_prefix(event_prefixes[ev_type])
			string = string.trim_prefix("(").trim_suffix(")")
			match ev_type:
				EventType.KEY:
					var keycode = OS.find_keycode_from_string(string)
					var event = InputEventKey.new()
					event.keycode = keycode
					return event
				EventType.KEY_PHYSICAL:
					var keycode = OS.find_keycode_from_string(string)
					var event = InputEventKey.new()
					event.physical_keycode = keycode
					return event
				EventType.MOUSE_BUTTON:
					var button_index = int(string)
					var event = InputEventMouseButton.new()
					event.button_index = button_index
					return event 
	return null


func save_keys(is_default : bool):
	var file_n = file_name
	if is_default:
		file_n = file_name_default
	var key_dict = gen_dict_from_input_map()
	var raw = FileAccess.open(file_n, FileAccess.WRITE)
	raw.store_string(var_to_str(key_dict))
	raw.close()
	print("saved keys")
