@tool
extends Resource
class_name TailRes

var _tail_data : TailData
@export var _tail_name : String
@export_multiline var _attribs_str : String
@export var _tail_class : Tails.Types
@export var _skill_name : String
@export var _skill_animation : String
@export var _adtnl_max_health : int = 0
@export var _adtnl_armor : int = 0
@export var _adtnl_speed : int = 0
@export var _adtnl_footstep_silencer : int = 0
@export var _adtnl_dmg : int = 0


func get_tail_data():
	_tail_data = TailData.new()
	_tail_data.set_data(
		_tail_name,
		_attribs_str,
		_tail_class,
		_skill_name,
		_skill_animation,
		_adtnl_max_health,
		_adtnl_armor,
		_adtnl_speed,
		_adtnl_footstep_silencer,
		_adtnl_dmg
	)
	
	return _tail_data
