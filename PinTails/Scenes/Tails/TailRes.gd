@tool
extends Resource
class_name TailRes

var _tail_data : TailData
@export var _tail_name : String
@export var _tail_attribs_str : String # (String, MULTILINE)
@export var _tail_class : int = 0 # (TailTypes.Types)
@export var _tail_active_attrb : String
@export var _adtnl_max_health : int = 0
@export var _adtnl_armor : int = 0
@export var _adtnl_speed : int = 0


func get_tail_data():
	_tail_data = TailData.new()
	_tail_data.set_data(
		_tail_name,
		_tail_attribs_str,
		_tail_class,
		_tail_active_attrb,
		_adtnl_max_health,
		_adtnl_armor,
		_adtnl_speed
	)
	
	return _tail_data
