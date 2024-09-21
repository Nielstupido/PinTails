class_name TailData


var tail_name : String
var attrb_str : String

var tail_class : int = 0
var skill_name : String
var skill_animation : String
var adtnl_max_health : int = 0
var adtnl_armor : int = 0
var adtnl_movement_speed : int = 0
var adtnl_footstep_silencer : int = 0
var adtnl_melee_dmg : int = 0


func set_data(
	new_tail_name = "",
	new_attrb_str = "",
	new_tail_class = 0,
	new_skill_name = "",
	new_skill_animation = "",
	new_adtnl_max_health = 0,
	new_adtnl_armor = 0,
	new_adtnl_movement_speed = 0,
	new_adtnl_footstep_silencer = 0,
	new_adtnl_melee_dmg = 0
):
	self.tail_name = new_tail_name
	self.attrb_str = new_attrb_str
	self.tail_class = new_tail_class
	self.skill_name = new_skill_name
	self.skill_animation = new_skill_animation
	self.adtnl_max_health = new_adtnl_max_health
	self.adtnl_armor = new_adtnl_armor
	self.adtnl_movement_speed = new_adtnl_movement_speed
	self.adtnl_footstep_silencer = new_adtnl_footstep_silencer
	self.adtnl_melee_dmg = new_adtnl_melee_dmg
