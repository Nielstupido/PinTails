extends "SettingsNode.gd"


#Override this function
func _get_value():
	return %Value.value


#Override this function
func _set_value(value):
	%Value.value = value
	%ValueStr.text = str(value)


#Override this function
func _on_value_edited():
	var new_value = get_value()
	%ValueStr.text = str(new_value)
	if new_value != Settings.get_setting(_setting_name):
		Settings.set_setting(_setting_name, new_value)


#Override this function
func _on_setting_attached():
#	%Value.connect("value_changed", self, "on_value_edited")
	%Name.text = _setting_name


func _on_value_value_changed(value):
	on_value_edited()
