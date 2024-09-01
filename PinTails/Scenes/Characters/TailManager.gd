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

@onready var tails = []
@onready var tail_obj = preload("res://Scenes/Tails/Tail.tscn")
var current_active_tail_attrb : Array


func _ready():
	GAMEMANAGER.connect("tail_picked_up", Callable(self, "set_tail_attr"))
	
	#<<<Testing>>>
	add_tail(MATCHMANAGER.match_players.get(MATCHMANAGER.player_name), GAMEMANAGER.get_tail_id())
	GAMEMANAGER.emit_signal("tail_picked_up", tails[tails.size() - 1])
	#<<<Testing>>>


func add_tail(passed_tail, passed_tail_id = -1) -> bool:
	if !tails.has(passed_tail):
		if passed_tail_id != -1:
			passed_tail.id = passed_tail_id
		tails.append(passed_tail)
		print("passed tail == " + str(passed_tail))
		return true
	 
	return false


func remove_tail(passed_tail):
	var tail_instance = tail_obj.instantiate()
	tail_instance.position = owner.player_interaction_component.get_interaction_raycast_tip(0)
	tail_instance.prepare_tail(passed_tail)
	GAMEMANAGER.get_node(".").add_child(tail_instance)
	
	tails.erase(passed_tail)
	remove_tail_attr(passed_tail)


#adds/sets the attributes of the newly pinned tail to player
func set_tail_attr(passed_tail_data):
	current_active_tail_attrb.append(passed_tail_data.tail_active_attrb)
	owner.adtnl_movement_speed = passed_tail_data.adtnl_movement_speed
	owner.adtnl_armor = passed_tail_data.adtnl_armor
	owner.adtnl_max_health = passed_tail_data.adtnl_max_health
	owner.adtnl_footstep_silencer = passed_tail_data.adtnl_footstep_silencer
	owner.adtnl_melee_dmg = passed_tail_data.adtnl_melee_dmg


#removes the attributes of the removed tail from player
func remove_tail_attr(passed_tail_data):
	current_active_tail_attrb.erase(passed_tail_data.tail_active_attrb)
	owner.adtnl_movement_speed -= passed_tail_data.adtnl_movement_speed
	owner.adtnl_armor -= passed_tail_data.adtnl_armor
	owner.adtnl_max_health -= passed_tail_data.adtnl_max_health
	owner.adtnl_footstep_silencer -= passed_tail_data.adtnl_footstep_silencer
	owner.adtnl_melee_dmg -= passed_tail_data.adtnl_melee_dmg


func get_skill_CD(skill_name : String) -> int:
	return Active_tail_attrb[skill_name]["CD"]
