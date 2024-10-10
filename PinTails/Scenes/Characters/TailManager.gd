class_name TailManager
extends Node

@onready var tails = []
@onready var tail_obj = preload("res://Scenes/Tails/Tail.tscn")
var current_active_tail_attrb : Array


func _ready():
	GAMEMANAGER.connect("tail_picked_up", Callable(self, "set_tail_attr"))


func add_tail(passed_tail : TailData) -> bool:
	if !tails.has(passed_tail):
		tails.append(passed_tail)
		print("passed tail == " + str(passed_tail))
		return true
	
	return false


func remove_tail(passed_tail : TailData) -> void:
	var tail_instance = tail_obj.instantiate()
	tail_instance.position = owner.player_interaction_component.get_interaction_raycast_tip(0)
	tail_instance.tail_data = passed_tail
	GAMEMANAGER.get_node(".").add_child(tail_instance)
	
	tails.erase(passed_tail)
	remove_tail_attr(passed_tail)


#adds/sets the attributes of the newly pinned tail to player
func set_tail_attr(passed_tail_data : TailData) -> void:
	current_active_tail_attrb.append(passed_tail_data.skill_name)
	owner.adtnl_movement_speed = passed_tail_data.adtnl_movement_speed
	owner.adtnl_armor = passed_tail_data.adtnl_armor
	owner.adtnl_max_health = passed_tail_data.adtnl_max_health
	owner.adtnl_footstep_silencer = passed_tail_data.adtnl_footstep_silencer
	owner.adtnl_melee_dmg = passed_tail_data.adtnl_melee_dmg


#removes the attributes of the removed tail from player
func remove_tail_attr(passed_tail_data : TailData) -> void:
	current_active_tail_attrb.erase(passed_tail_data.skill_name)
	owner.adtnl_movement_speed -= passed_tail_data.adtnl_movement_speed
	owner.adtnl_armor -= passed_tail_data.adtnl_armor
	owner.adtnl_max_health -= passed_tail_data.adtnl_max_health
	owner.adtnl_footstep_silencer -= passed_tail_data.adtnl_footstep_silencer
	owner.adtnl_melee_dmg -= passed_tail_data.adtnl_melee_dmg
