class_name TailManager
extends Node


const Active_tail_attrb = {
	"Poison Stab" : 
		{"Effect" : GAMEMANAGER.SkillEffects.DAMAGE, 
		"Type" : GAMEMANAGER.SkillTypes.SINGLE_TRIGGER,
		"Value" : 20, 
		"CD" : 8},
	"Dash" : 
		{"Effect" : GAMEMANAGER.SkillEffects.DASH, 
		"Type" : GAMEMANAGER.SkillTypes.SINGLE_TRIGGER,
		"Value" : 15,  
		"CD" : 3},
	"Horn Charge" : 
		{"Effect" : GAMEMANAGER.SkillEffects.DAMAGE, 
		"Type" : GAMEMANAGER.SkillTypes.SINGLE_TRIGGER,
		"Value" : 20, 
		"CD" : 12},
	"Ball Roll" : 
		{"Effect" : GAMEMANAGER.SkillEffects.ARMOR, 
		"Type" : GAMEMANAGER.SkillTypes.SINGLE_TRIGGER,
		"Value" : 100, 
		"CD" : 12},
	"Pounce" : 
		{"Effect" : GAMEMANAGER.SkillEffects.DAMAGE, 
		"Type" : GAMEMANAGER.SkillTypes.SINGLE_TRIGGER,
		"Value" : 30, 
		"CD" : 8},
	"Wall Run" : 
		{"Effect" : GAMEMANAGER.SkillEffects.STICK, 
		"Type" : GAMEMANAGER.SkillTypes.SINGLE_TRIGGER,
		"Value" : 0, 
		"CD" : 10}
}

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


func get_skill_effect(skill_name : String) -> GAMEMANAGER.SkillEffects:
	return Active_tail_attrb[skill_name]["Effect"]


func get_skill_type(skill_name : String) -> GAMEMANAGER.SkillTypes:
	return Active_tail_attrb[skill_name]["Type"] 


func get_skill_value(skill_name : String) -> int:
	return Active_tail_attrb[skill_name]["Value"]


func get_skill_CD(skill_name : String) -> int:
	return Active_tail_attrb[skill_name]["CD"]
