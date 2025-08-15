class_name TailSkill
extends Node


var _calling_node
var _skill_card_node
var _is_activated : bool = false


#Override this function
func _execute_skill(value):
	pass


#Override this function
func stop_skill():
	pass


func execute_skill(value, calling_node, skill_card_node):
	_calling_node = calling_node
	_skill_card_node = skill_card_node
	_execute_skill(value)


func deactivate():
	_is_activated = false
