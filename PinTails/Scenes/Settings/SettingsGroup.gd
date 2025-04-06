extends VBoxContainer


@export var group_name : String :
	set(value):
		set_group_name(value)
	get:
		return get_group_name()


func set_group_name(value : String):
	%GroupName.text = value


func get_group_name():
	return %GroupName.text


func add_editor(value : Node): 
	%SettingsList.add_child(value)
