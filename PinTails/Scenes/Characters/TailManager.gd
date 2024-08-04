class_name TailManager
extends Node


const Active_tail_attrb = {
	"Poison Stab" : {"Damage" : 20, "CD" : 8},
	"Dash" : {"Dash" : 80, "CD" : 6},
	"Horn Charge" : {"Damage" : 30, "CD" : 12},
	"Ball Roll" : {"Armor" : 100, "CD" : 12},
	"Pounce" : {"Damage" : 30, "CD" : 8},
	"Untouchable" : {"Stick" : 0, "CD" : 10}
}


func _ready():
	GAMEMANAGER.connect("tail_picked_up", self, "set_tail_attr")


#adds/sets the attributes of the newly pinned tail to player
func set_tail_attr(passed_tail_data):
	owner.current_active_tail_attrb.append(passed_tail_data.tail_active_attrb)
	owner.adtnl_movement_speed = passed_tail_data.adtnl_movement_speed
	owner.adtnl_armor = passed_tail_data.adtnl_armor
	owner.adtnl_max_health = passed_tail_data.adtnl_max_health
	owner.adtnl_footstep_silencer = passed_tail_data.adtnl_footstep_silencer
	owner.adtnl_melee_dmg = passed_tail_data.adtnl_melee_dmg


#removes the attributes of the removed tail from player
func remove_tail_attr(passed_tail_data):
	owner.current_active_tail_attrb.remove(owner.current_active_tail_attrb.find(passed_tail_data.tail_active_attrb))
	owner.adtnl_movement_speed -= passed_tail_data.adtnl_movement_speed
	owner.adtnl_armor -= passed_tail_data.adtnl_armor
	owner.adtnl_max_health -= passed_tail_data.adtnl_max_health
	owner.adtnl_footstep_silencer -= passed_tail_data.adtnl_footstep_silencer
	owner.adtnl_melee_dmg -= passed_tail_data.adtnl_melee_dmg


func get_skill_CD(skill_name : String) -> int:
	return Active_tail_attrb[skill_name]["CD"]
