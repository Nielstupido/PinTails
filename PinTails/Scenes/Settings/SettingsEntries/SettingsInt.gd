extends "SettingsNode.gd"


#Override this function
func _get_value():
	return int(%Value.value)


#Override this function
func _set_value(value):
	%Value.value = value


#Override this function
func _on_value_edited():
	var new_value = get_value()
	if new_value != Settings.get_setting(_setting_name):
		Settings.set_setting(_setting_name, new_value)


#Override this function 
func _on_setting_attached():
	%Value.min_value = Settings.get_setting_min_value(_setting_name)
	%Value.max_value = Settings.get_setting_max_value(_setting_name)
	%Value.step = Settings.get_setting_step(_setting_name)
#	%Value.connect("value_changed", self, "on_value_edited")
	%Name.text = _setting_name


func _on_value_value_changed(value):
	on_value_edited()
