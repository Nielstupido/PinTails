class_name TailData


var id : int = 0
var tail_name : String
var tail_attrb_str : String

var tail_class : int = 0
var tail_active_attrb : String
var adtnl_max_health : int = 0
var adtnl_armor : int = 0
var adtnl_movement_speed : int = 0
var adtnl_footstep_silencer : int = 0
var adtnl_melee_dmg : int = 0


func set_data(
	tail_data : TailData = null,
	new_tail_name = "",
	new_tail_attrb_str = "",
	new_tail_class = 0,
	new_tail_active_attrb = "",
	new_adtnl_max_health = 0,
	new_adtnl_armor = 0,
	new_adtnl_movement_speed = 0
):
	if (tail_data != null):
		self.id = tail_data.id
		self.tail_name = tail_data.tail_name
		self.tail_attrb_str = tail_data.tail_attrb_str
		self.tail_class = tail_data.tail_class
		self.tail_active_attrb = tail_data.tail_active_attrb
		self.adtnl_max_health = tail_data.adtnl_max_health
		self.adtnl_armor = tail_data.adtnl_armor
		self.adtnl_movement_speed = tail_data.adtnl_movement_speed
		return
	
	self.tail_name = new_tail_name
	self.tail_attrb_str = new_tail_attrb_str
	self.tail_class = new_tail_class
	self.tail_active_attrb = new_tail_active_attrb
	self.adtnl_max_health = new_adtnl_max_health
	self.adtnl_armor = new_adtnl_armor
	self.adtnl_movement_speed = new_adtnl_movement_speed
