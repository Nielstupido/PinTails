extends Control

onready var tail_holder1 = $HBoxContainer/TailMenuHolder
onready var tail_holder2 = $HBoxContainer/TailMenuHolder2
onready var tail_holder3 = $HBoxContainer/TailMenuHolder3
var tails : Dictionary
var temp_tail_data
var tails_side_bar


func _ready():
	tails_side_bar = owner.get_node("UI/TailsSideBar")


func add_tail(tail_data):
	match(tails.size()):
		0:
			tail_holder1.get_node("TailCard").prepare_tail_card(tail_data)
		1:
			tail_holder2.get_node("TailCard").prepare_tail_card(tail_data)
		2:
			tail_holder3.get_node("TailCard").prepare_tail_card(tail_data)
	
	tails[tails.size()] = tail_data


func remove_tail(tail_data):
	var removed_tail_key : int
	owner.remove_tail(tail_data)
	
	for key in tails.keys():
		if tail_data == tails.get(key):
			removed_tail_key = key
			tails.erase(key)
			tails_side_bar.remove_tail(removed_tail_key)
			
		if tails.size() == 0:
			return
	
	if removed_tail_key == 0:
		tail_holder1.get_node("TailCard").prepare_tail_card(tail_holder2.get_node("TailCard").tail_data)
		if tail_holder3.get_node("TailCard").tail_data:
			tail_holder2.get_node("TailCard").prepare_tail_card(tail_holder3.get_node("TailCard").tail_data)
	elif removed_tail_key == 1:
		if tail_holder3.get_node("TailCard").tail_data:
			tail_holder2.get_node("TailCard").prepare_tail_card(tail_holder3.get_node("TailCard").tail_data)
	
	tail_holder3.get_node("TailCard").clear_tail_card()
