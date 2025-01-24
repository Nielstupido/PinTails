class_name TailData
extends Resource


var tail_class : int = 0
var attrb_str : String

var adtnl_max_health : int = 0
var adtnl_armor : int = 0
var adtnl_movement_speed : int = 0
var adtnl_footstep_silencer : int = 0
var adtnl_melee_dmg : int = 0

var skill_name : String
var skill_animation : String
var skill_effect : SKILLS.Skill_Effects
var skill_type : SKILLS.Skill_Types
var skill_value : int = 0
var skill_duration : int = 0
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
	new_skill_effect= GAMEPLAYMANAGER.Skill_Effects.DEFAULT,
	new_skill_type = GAMEPLAYMANAGER.Skill_Types.DEFAULT,
	new_skill_value = 0,
	new_skill_duration = 0,
	new_skill_cd = 0,
) -> void:
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
	self.skill_duration = new_skill_duration
	self.skill_cd = new_skill_cd


func set_string_to_data(data_dict : Dictionary) -> void:
	self.tail_class = data_dict["tail_class"]
	self.attrb_str = data_dict["attrb_str"]
	self.adtnl_max_health = data_dict["adtnl_max_health"]
	self.adtnl_armor = data_dict["adtnl_armor"]
	self.adtnl_movement_speed = data_dict["adtnl_movement_speed"]
	self.adtnl_footstep_silencer = data_dict["adtnl_footstep_silencer"]
	self.adtnl_melee_dmg = data_dict["adtnl_melee_dmg"]
	self.skill_name = data_dict["skill_name"]
	self.skill_animation = data_dict["skill_animation"]
	self.skill_effect = data_dict["skill_effect"]
	self.skill_type = data_dict["skill_type"]
	self.skill_value = data_dict["skill_value"]
	self.skill_duration = data_dict["skill_duration"]
	self.skill_cd = data_dict["skill_cd"]


func stringify() -> String:
	return JSON.stringify({
		"tail_class" : self.tail_class,
		"attrb_str" : self.attrb_str,
		"adtnl_max_health" : self.adtnl_max_health,
		"adtnl_armor" : self.adtnl_armor,
		"adtnl_movement_speed" : self.adtnl_movement_speed,
		"adtnl_footstep_silencer" : self.adtnl_footstep_silencer,
		"adtnl_melee_dmg" : self.adtnl_melee_dmg,
		"skill_name" : self.skill_name,
		"skill_animation" : self.skill_animation,
		"skill_effect" : self.skill_effect,
		"skill_type" : self.skill_type,
		"skill_value" : self.skill_value,
		"skill_duration" : self.skill_duration,
		"skill_cd" : self.skill_cd
		})
