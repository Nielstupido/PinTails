extends "SettingsNode.gd"


var is_waiting_input : bool = false
var temp_setting_name : String = ""


# Override this function
func _get_value():
	return str(%Value.text)


# Override this function
func _set_value(value):
	%Value.text = ""
	if value == null:
		return
	
	match value:
		"Ctrl":
			value = "Control"
		"Mouse Button 1":
			value = "Mouse Left Button"
		"Mouse Button 2":
			value = "Mouse Right Button"
		"Mouse Button 3":
			value = "Mouse Middle Button"
		"Mouse Button 4":
			value = "Mouse Wheel Up"
		"Mouse Button 5":
			value = "Mouse Wheel Down"
	%Value.text = value


# Override this function
func _on_value_edited():
	var new_value = get_value()
	if new_value != Settings.get_setting(_setting_name):
		Settings.set_setting(_setting_name, new_value)


# Override this function
func _on_setting_attached():
#	%Value.connect("value_changed", self, "on_value_edited")
	temp_setting_name = _setting_name
	
	if "movement|" in temp_setting_name:
		temp_setting_name = temp_setting_name.erase(0, 9)
		
	elif "player|" in temp_setting_name:
		temp_setting_name = temp_setting_name.erase(0, 7)
		
	elif "playerhand|" in temp_setting_name:
		temp_setting_name = temp_setting_name.erase(0, 11)
		
	elif "itm|" in temp_setting_name:
		temp_setting_name = temp_setting_name.erase(0, 4)
		
	elif "ablty|" in temp_setting_name:
		temp_setting_name = temp_setting_name.erase(0, 6)
		
	temp_setting_name = temp_setting_name.replace("_", " ")
	%Name.text = temp_setting_name[0].to_upper() + temp_setting_name.substr(1,-1)


func _on_Value_value_changed(value):
	on_value_edited()


func _input(event):
	if not get_parent().get_parent().get_parent().get_parent().owner.get_node("ChangeKeyPanel").visible:
		is_waiting_input = false
		
	if is_waiting_input:
		if not event is InputEventMouseMotion:
			get_viewport().set_input_as_handled()
			
			if event is InputEventMouseButton:
				print("Mouse Button " + str(event.get_button_index()))
			elif event is InputEventJoypadButton:
				print("Joypad Button " + str(event.get_button_index()))
			elif event is InputEventJoypadMotion:
				print("Joypad Motion " + str(event.get_axis()))
			elif event is InputEventKey:
				if event.physical_keycode:
					if event.physical_keycode == 16777217:
						return
				else:
					if event.keycode == 16777217:
						return
			
			get_parent().get_parent().get_parent().get_parent().owner.get_node("ChangeKeyPanel").hide()
			is_waiting_input = false
			Settings.set_setting(_setting_name, event)


func _on_change_pressed():
	get_parent().get_parent().get_parent().get_parent().owner.get_node("ChangeKeyPanel").show()
	is_waiting_input = true


func _on_clear_pressed():
	Settings.set_setting(_setting_name, null)
