extends Node

var file_name = "%s://Scenes/Globals/Settings/settings_config.dict" % ("user" if OS.has_feature("standalone") else "res")
var file_name_default = "%s://Scenes/Globals/Settings/default_settings.dict" % ("user" if OS.has_feature("standalone") else "res")

#var file_name = "%s://globals/settings/settings_config.dict" % ("user")
#var file_name_default = "%s://globals/settings/default_settings.dict" % ("user")

var setting_key = false

enum value_types {
	BOOL,
	FLOAT
}

var value_prefixes = [
	"bool", 
	"float"
]

var settings_names = [
	"is_crouch_hold",
	"is_ads_hold",
	"mouse_sensitivity",
	"master_volume",
	"music_volume",
	"effects_volume",
	"voice_volume",
	"fullscreen",
	"brightness",
	"gui_scale"
]


func _ready():
	load_settings_config()


func load_settings_config():
	if(FileAccess.file_exists(file_name)):
		var file = FileAccess.open(file_name, FileAccess.READ)
		var file_str = file.get_as_text()
		file.close()
		var data = str_to_var(file_str)
		if(typeof(data) == TYPE_DICTIONARY):
			setup_settings(data)
		else:
			printerr("corrupted data! " + str(typeof(data)))
	else:
		#NoFile, so lets save the default settings now
		save_settings()
		save_default_settings()


func setup_settings(settings_dict : Dictionary):

	for saved_setting in settings_dict.keys():
		var value = null
		if value_prefixes[0] in settings_dict[saved_setting]:
			value = settings_dict[saved_setting].trim_prefix(value_prefixes[0])
			value = value.trim_prefix("(").trim_suffix(")")
			if "false" in value:
				value = false
			elif "true" in value:
				value = true
			else:
				value = true
				
		else:
			value = settings_dict[saved_setting].trim_prefix(value_prefixes[1])
			value = value.trim_prefix("(").trim_suffix(")")
			value = value.to_float()
		
		
		match saved_setting:
			"is_crouch_hold":
				GameSettings.crouch_hold_enabled = value
			"is_ads_hold":
				GameSettings.ads_hold_enabled = value
				#print(saved_setting + " == " + str(GameSettings.ads_hold_enabled))
			"mouse_sensitivity":
				InputSettings.setting_mouse_sensitivity = value
			"master_volume":
				AudioSettings.setting_master_volume = value
			"music_volume":
				AudioSettings.setting_music_volume = value
			"effects_volume":
				AudioSettings.setting_effects_volume = value
			"voice_volume":
				AudioSettings.setting_voice_volume = value
			"fullscreen":
				VideoSettings.fullscreen_enabled = value
			"brightness":
				VideoSettings.brightness = value
			"gui_scale":
				VideoSettings.gui_scale = value


func save_settings():
	var key_dict = gen_dict_from_settings()
	var dir_path = file_name.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(var_to_str(key_dict))
	file.close()
	print("settings config saved")


func save_default_settings():
	var key_dict = gen_dict_from_settings()
	var dir_path = file_name_default.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)
	var file = FileAccess.open(file_name_default, FileAccess.WRITE)
	file.store_string(var_to_str(key_dict))
	file.close()
	print("settings default config saved")


func gen_dict_from_settings() -> Dictionary:
	var actions = InputMap.get_actions()
	var config = Dictionary()
	var value_type = value_types.BOOL
	
	for setting in settings_names:
		match setting:
			"is_crouch_hold":
				config[setting] = "%s(%s)" % [value_prefixes[value_types.BOOL], str(GameSettings.crouch_hold_enabled)]
			"is_ads_hold":
				config[setting] = "%s(%s)" % [value_prefixes[value_types.BOOL], str(GameSettings.ads_hold_enabled)]
			"mouse_sensitivity":
				config[setting] = "%s(%s)" % [value_prefixes[value_types.FLOAT], str(InputSettings.setting_mouse_sensitivity)]
			"master_volume":
				config[setting] = "%s(%s)" % [value_prefixes[value_types.FLOAT], str(AudioSettings.setting_master_volume)]
			"music_volume":
				config[setting] = "%s(%s)" % [value_prefixes[value_types.FLOAT], str(AudioSettings.setting_music_volume)]
			"effects_volume":
				config[setting] = "%s(%s)" % [value_prefixes[value_types.FLOAT], str(AudioSettings.setting_effects_volume)]
			"voice_volume":
				config[setting] = "%s(%s)" % [value_prefixes[value_types.FLOAT], str(AudioSettings.setting_voice_volume)]
			"fullscreen":
				config[setting] = "%s(%s)" % [value_prefixes[value_types.BOOL], str(VideoSettings.fullscreen_enabled)]
			"brightness":
				config[setting] = "%s(%s)" % [value_prefixes[value_types.FLOAT], str(VideoSettings.brightness)]
			"gui_scale":
				config[setting] = "%s(%s)" % [value_prefixes[value_types.FLOAT], str(VideoSettings.gui_scale)]
	
	return config
