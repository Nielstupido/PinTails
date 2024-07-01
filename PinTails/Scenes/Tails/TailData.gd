class_name TailData


var tail_name : String
var tail_attribs_str : String
var tail_class : int = 0
var adtnl_max_health : int = 0
var adtnl_armor : int = 0
var adtnl_speed : int = 0


func set_data(
	tail_data : TailData = null,
	new_tail_name = "",
	new_tail_attribs_str = "",
	new_tail_class = 0,
	new_adtnl_max_health = 0,
	new_adtnl_armor = 0,
	new_adtnl_speed = 0
):
	if (tail_data != null):
		self.tail_name = tail_data.tail_name
		self.tail_attribs_str = tail_data.tail_attribs_str
		self.tail_class = tail_data.tail_class
		self.adtnl_max_health = tail_data.adtnl_max_health
		self.adtnl_armor = tail_data.adtnl_armor
		self.adtnl_speed = tail_data.adtnl_speed
		return
	
	self.tail_name = new_tail_name
	self.tail_attribs_str = new_tail_attribs_str
	self.tail_class = new_tail_class
	self.adtnl_max_health = new_adtnl_max_health
	self.adtnl_armor = new_adtnl_armor
	self.adtnl_speed = new_adtnl_speed
