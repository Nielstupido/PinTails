@tool
class_name TailRes
extends Resource

var _tail_data : TailData
@export var _tail_class : Tail.Classes
@export_multiline var _attribs_str : String

@export_group("Tail Passive Attributes")
@export var _adtnl_max_health : int = 0
@export var _adtnl_armor : int = 0
@export var _adtnl_speed : int = 0
@export var _adtnl_footstep_silencer : int = 0
@export var _adtnl_dmg : int = 0

@export_group("Tail Active Attributes")
@export var _skill_name : String = ""
@export var _skill_animation : String = ""
@export var _skill_effect : Skills.Skill_Effects
@export var _skill_type :  Skills.Skill_Types
@export var _skill_value : int = 0
@export var _skill_duration : int = 0
@export var _skill_cd : int = 0


func get_tail_data():
	_tail_data = TailData.new()
	_tail_data.set_data(
		_tail_class,
		_attribs_str,
		_adtnl_max_health,
		_adtnl_armor,
		_adtnl_speed,
		_adtnl_footstep_silencer,
		_adtnl_dmg,
		_skill_name,
		_skill_animation,
		_skill_effect,
		_skill_type,
		_skill_value,
		_skill_duration,
		_skill_cd
	)
	
	return _tail_data
