extends MarginContainer


enum Settings_Category {
	AUDIO_SETTINGS,
	VIDEO_SETTINGS,
	GAME_SETTINGS,
	INPUT_SETTINGS,
}

#export var default_group_name = "Game Settings"
@export var sett_category : Settings_Category

const SetDefaultKeyBtn = preload("res://Scenes/Settings/SetDefaultKeys.tscn")
const BlankRowScene = preload("res://Scenes/Settings/BlankRowScene.tscn")
const GroupScene = preload("res://Scenes/Settings/SettingsGroup.tscn")
const GroupClass = preload("res://Scenes/Settings/SettingsGroup.gd")
const SettingsNode = preload("res://Scenes/Settings/SettingsEntries/SettingsNode.gd")

const SettingsEditors = {
	Settings.SettingType.BOOL : preload("res://Scenes/Settings/SettingsEntries/SettingsBool.tscn"),
	Settings.SettingType.FLOAT : preload("res://Scenes/Settings/SettingsEntries/SettingsFloat.tscn"),
	Settings.SettingType.ENUM : preload("res://Scenes/Settings/SettingsEntries/SettingsEnum.tscn"),
	Settings.SettingType.INT : preload("res://Scenes/Settings/SettingsEntries/SettingsInt.tscn"),
	Settings.SettingType.STRING : preload("res://Scenes/Settings/SettingsEntries/SettingsString.tscn"),
}

var group_nodes : Dictionary = Dictionary()
var is_first_settings : bool = true
var is_first_key_settings : bool = true
var is_done : bool = false
var index : int = 0
var counter : int = 0


func _ready():
	attach_settings(false)


func attach_settings(be_sorted : bool):
	clear_ui()
	generate_ui()
	
	#if be_sorted:
		#sort_setting_groups()


func clear_ui():
	for k in group_nodes.keys():
		group_nodes[k].queue_free()
	group_nodes.clear()


func generate_ui():
	is_first_settings = true
	is_first_key_settings = true
	
	for _s in Settings.get_settings_list():
		var setting_name = _s as String
		
		match(sett_category):
			Settings_Category.AUDIO_SETTINGS:
				if "Audio" in Settings.get_setting_group(setting_name):
					add_setting(setting_name)
			Settings_Category.VIDEO_SETTINGS:
				if "Video" in Settings.get_setting_group(setting_name):
					add_setting(setting_name)
			Settings_Category.GAME_SETTINGS:
				if "Game" in Settings.get_setting_group(setting_name):
					add_setting(setting_name)
			Settings_Category.INPUT_SETTINGS:
				if "Input Key" in Settings.get_setting_group(setting_name):
					add_setting(setting_name)


func sort_setting_groups():
	while not is_done:
		index = -1
		counter = 0
		
		for child in $SettingsList.get_children():
			index += 1
			
			if child.has_method("get_group_name"):
				if "Game" in str(child.group_name):
					if index != 0:
						swap_child(child, 0, index)
						break
					else:
						counter += 1
				elif "Video" in str(child.group_name):
					if index != 2:
						swap_child(child, 2, index)
						break
					else:
						counter += 1
				elif "Audio" in str(child.group_name):
					if index != 4:
						swap_child(child, 4, index)
						break
					else:
						counter += 1
				elif "Input" in str(child.group_name) and not "Key" in str(child.group_name):
					if index != 6:
						swap_child(child, 6, index)
						break
					else:
						counter += 1
				elif "Input Key" in str(child.group_name):
					if index != 8:
						swap_child(child, 8, index)
						break
					else:
						counter += 1
		
		if counter == 5:
			is_done = true


func swap_child(child : Node, target_index : int, current_index : int):
	move_child(child, $SettingsList.get_child_count() - 1)
	move_child($SettingsList.get_child(target_index - 1), current_index) 
	move_child(child, target_index) 
	counter += 1


func add_setting(setting_name : String):
	var group_name = Settings.get_setting_group(setting_name)
#	group_name = group_name if group_name else default_group_name
	var settings_group : GroupClass = get_group_node(group_name)
	if settings_group == null:
		add_group(group_name)
		settings_group = get_group_node(group_name)
	
	if group_name == "Input Key Settings" and is_first_key_settings:
		is_first_key_settings = false
		settings_group.add_editor(SetDefaultKeyBtn.instantiate())
		settings_group.get_node("ListOffset/SettingsList/SetDefaultKeys/Button").connect("pressed", 
				Callable($ResetPanel, "toggle_panel"))
	
	var setting_editor = SettingsEditors[Settings.get_setting_type(setting_name)].instantiate() as SettingsNode
	settings_group.add_editor(setting_editor)
	setting_editor.attach_setting(setting_name)


func add_group(group_name : String) -> bool:
	if group_nodes.has(group_name):
		return false
	
	if is_first_settings:
		is_first_settings = false
	else:
		add_blank_row()
	
	var new_group = GroupScene.instantiate()
	$SettingsList.add_child(new_group) 
	group_nodes[group_name] = new_group
	new_group.group_name = str(group_name) + "\n"
	return true


func add_blank_row() -> void:
	var new_group = BlankRowScene.instantiate()
	$SettingsList.add_child(new_group)


func has_group(group_name : String) -> bool:
	return group_nodes.has(group_name)


func get_group_node(group_name : String) -> GroupClass:
	return group_nodes.get(group_name)


func _on_ShowDebugOptions_pressed():
	$"..".visible = !$"..".visible
