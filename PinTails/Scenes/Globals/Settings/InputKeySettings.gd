extends Node


const GROUP_NAME : String = "Input Key Settings"

var setting_key_inputs : String = ""
var is_waiting_input : bool = false
var event
var actions : PackedStringArray = []
var actions_copy : PackedStringArray
var flag : int = 1
var index : int = 0
var is_done : bool = false
var key_removed : bool = false
var arr_size : int = 0
var safe_counter : int = 0
var counter : int = 0
var counter_max : int = 0

const MAX_VALUE = 4.0
const STEP_VALUE = 0.05
const MIN_VALUE = 0.05

var setting_action_event : float :
	set = set_action_event, 
	get = get_action_event


func _ready():
	actions_copy.append_array(InputMap.get_actions())
	
	while not is_done:
		safe_counter += 1
		key_removed = false
		arr_size = actions_copy.size()
		index = -1
		
		for x in range(arr_size):
			if not "ui_" in actions_copy[x] and not "debug_" in actions_copy[x]:
				match flag:
					1:
						if "movement|forward" in actions_copy[x] and counter == 0:
							set_keys(x)
						elif "movement|left" in actions_copy[x] and counter == 1:
							set_keys(x)
						elif "movement|right" in actions_copy[x] and counter == 2:
							set_keys(x)
						elif "movement|backward" in actions_copy[x] and counter == 3:
							set_keys(x)
					2:
						if "player|crouch" in actions_copy[x] and counter == 0:
							set_keys(x)
						elif "player|pick_up" in actions_copy[x] and counter == 1:
							set_keys(x)
						elif "player|jump" in actions_copy[x] and counter == 2:
							set_keys(x)
						elif "player|reload" in actions_copy[x] and counter == 2:
							set_keys(x)
						elif "player|sprint" in actions_copy[x] and counter == 3:
							set_keys(x)
						elif "player|roll" in actions_copy[x] and counter == 4:
							set_keys(x)
						elif "player|attach_tail" in actions_copy[x] and counter == 5:
							set_keys(x)
						elif "player|shoulder_change" in actions_copy[x] and counter == 6:
							set_keys(x)
						elif "player|radial_menu" in actions_copy[x] and counter == 7:
							set_keys(x)
						elif "player|holster" in actions_copy[x] and counter == 8:
							set_keys(x)
					3:
						if "playerhand|action_primary" in actions_copy[x] and counter == 0:
							set_keys(x)
						elif "playerhand|action_secondary" in actions_copy[x] and counter == 1:
							set_keys(x)
						elif "playerhand|fire" in actions_copy[x] and counter == 2:
							set_keys(x)
						elif "playerhand|aim" in actions_copy[x] and counter == 3:
							set_keys(x)
					4:
						if "itm|next_weapon" in actions_copy[x] and counter == 0:
							set_keys(x)
						elif "itm|prev_weapon" in actions_copy[x] and counter == 1:
							set_keys(x)
					#5:
						#if str(counter + 1) in actions_copy[x] and counter < 10:
							#if (counter + 1) == 1 and ( "11" in actions_copy[x] or "10" in actions_copy[x]):
								#pass
							#else:
								#set_keys(x)
					5:
						if "ablty|skill_trigger_primary" in actions_copy[x] and counter == 0:
							set_keys(x)
						elif "ablty|skill_trigger_secondary" in actions_copy[x] and counter == 1:
							set_keys(x)
						elif "ablty|first_skill" in actions_copy[x] and counter == 2:
							set_keys(x)
						elif "ablty|second_skill" in actions_copy[x] and counter == 3:
							set_keys(x)
						elif "ablty|third_skill" in actions_copy[x] and counter == 4:
							set_keys(x)
					_:
						actions_copy.remove_at(actions_copy.find(actions_copy[x]))
						key_removed = true
			else:
				actions_copy.remove_at(actions_copy.find(actions_copy[x]))
				key_removed = true
			
			index = x
			if key_removed:
				break
			
		if index == arr_size - 1: 
			if counter == counter_max:
				flag += 1
				counter = 0
			
			match flag:
				1:
					counter_max = 4
				2:
					counter_max = 9
				3:
					counter_max = 4
				4:
					counter_max = 2
				5:
					counter_max = 5
		if actions_copy.size() < 1 or safe_counter > 100:
			is_done = true
	
	Settings.connect("setting_changed", Callable(self, "on_setting_changed")) 


func set_keys(x):
	if InputMap.action_get_events(actions_copy[x]):
		var raw_event = InputMap.action_get_events(actions_copy[x])[0]
		if raw_event is InputEventMouseButton:
			event = "Mouse Button " + str(raw_event.button_index)
		elif raw_event is InputEventJoypadButton:
			event = "Joypad Button " + str(raw_event.button_index)
		elif raw_event is InputEventJoypadMotion:
			pass
		else:
			if raw_event.physical_keycode:
				event = str(OS.get_keycode_string(raw_event.physical_keycode))
			else:
				event = str(OS.get_keycode_string(raw_event.keycode))
	else:
		event = null
	
	actions.append(actions_copy[x])
	Settings.add_string_setting(actions_copy[x], event)
	Settings.set_setting_group(actions_copy[x], GROUP_NAME)
	actions_copy.remove_at(actions_copy.find(actions_copy[x]))
	key_removed = true
	counter += 1


func _input(event):
	if event is InputEvent and is_waiting_input:
		print("key pressed " + str(OS.get_keycode_string(event.physical_keycode)))


func set_action_event(value : float):
	is_waiting_input = true
	Settings.set_setting(setting_key_inputs, value)


func get_action_event() -> float:
	return Settings.get_setting(setting_key_inputs)


func set_event(setting_name, old_value, new_value):
	if new_value == null:
		InputMap.action_erase_events(setting_name)
	else:
		var events_setting = InputMap.action_get_events(setting_name)
		if events_setting.size() >= 1:
			InputMap.action_erase_event(setting_name, events_setting[0])
		InputMap.action_add_event(setting_name, new_value)
	
	KeybindingManager.save_keys(false)
	save_keys(setting_name, old_value)


func save_keys(setting_name : String, old_value):
	if InputMap.action_get_events(setting_name):
		var raw_event = InputMap.action_get_events(setting_name)[0]
		
		if raw_event is InputEventMouseButton:
			event = "Mouse Button " + str(raw_event.button_index)
		elif raw_event is InputEventJoypadButton:
			event = "Joypad Button " + str(raw_event.button_index)
		else:
			if raw_event.physical_keycode:
				event = str(OS.get_keycode_string(raw_event.physical_keycode))
			else:
				event = str(OS.get_keycode_string(raw_event.keycode))
	else:
		event = null
	
	if old_value == null:
		old_value = Settings.get_setting(setting_name)
	
	#Settings.set_setting(setting_name, events)
	Settings.emit_signal("keys_saved", setting_name, old_value, event)


func on_setting_changed (setting_name, old_value, new_value):
	if new_value is String and new_value == "all":
		reset_actions()
	elif actions.has(setting_name):
		set_event(setting_name, old_value, new_value)


func reset_actions():
	for action in actions:
		InputMap.action_erase_events(action)
		 
		var has_invalid : bool = false
		var events_arr = Array()  
		for event_str in KeybindingManager.keys_default[action]:
			var event = KeybindingManager.str_to_event(event_str)
			
			if event:
				events_arr.push_back(event)
			else:
				has_invalid = true
		
		if not has_invalid:
			InputMap.action_erase_events(action)
		for event in events_arr:
			InputMap.action_add_event(action, event)
		
		save_keys(action, null)
	
	KeybindingManager.save_keys(false)
