class_name TailData


var tail_class : int = 0
var attrb_str : String

var adtnl_max_health : int = 0
var adtnl_armor : int = 0
var adtnl_movement_speed : int = 0
var adtnl_footstep_silencer : int = 0
var adtnl_melee_dmg : int = 0

var skill_name : String
var skill_animation : String
var skill_effect : GAMEMANAGER.Skill_Effects
var skill_type : GAMEMANAGER.Skill_Types
var skill_value : int = 0
var skill_cd : int = 0


func set_data(
	new_tail_class = 0,
	new_attrb_str = "",
	new_adtnl_max_health = 0,
	new_adtnl_armor = 0,
	new_adtnl_movement_speed = 0,
	new_adtnl_footstep_silencer = 0,
	new_adtnl_melee_dmg = 0,
	new_skill_name = "",
	new_skill_animation = "",
	new_skill_effect= GAMEMANAGER.Skill_Effects.DEFAULT,
	new_skill_type = GAMEMANAGER.Skill_Types.DEFAULT,
	new_skill_value = 0,
	new_skill_cd = 0,
):
	self.tail_class = new_tail_class
	self.attrb_str = new_attrb_str
	self.adtnl_max_health = new_adtnl_max_health
	self.adtnl_armor = new_adtnl_armor
	self.adtnl_movement_speed = new_adtnl_movement_speed
	self.adtnl_footstep_silencer = new_adtnl_footstep_silencer
	self.adtnl_melee_dmg = new_adtnl_melee_dmg
	self.skill_name = new_skill_name
	self.skill_animation = new_skill_animation
	self.skill_effect = new_skill_effect
	self.skill_type = new_skill_type
	self.skill_value = new_skill_value
	self.skill_cd = new_skill_cd
