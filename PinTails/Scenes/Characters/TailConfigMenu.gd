extends Control

onready var tail_card1 = $HBoxContainer/TailMenuHolder/TailCard
onready var tail_card2 = $HBoxContainer/TailMenuHolder2/TailCard
onready var tail_card3 = $HBoxContainer/TailMenuHolder3/TailCard
var tails : Array
var tails_side_bar
var player_skills_bar


func _ready():
	GAMEMANAGER.connect("tail_picked_up", self, "add_tail")
	tails_side_bar = owner.get_node("UI/TailsSideBar")
	player_skills_bar = owner.get_node("UI/PlayerSkills")


func add_tail(tail_data):
	match(tails.size()):
		0:
			tail_card1.prepare_tail_card(tail_data)
		1:
			tail_card2.prepare_tail_card(tail_data)
		2:
			tail_card3.prepare_tail_card(tail_data)
	
	tails.append(tail_data)


func remove_tail(tail_data):
	var removed_tail_key : int
	owner.remove_tail(tail_data)
	
	removed_tail_key = tails.find(tail_data)
	tails.remove(removed_tail_key)
	tails_side_bar.remove_tail(removed_tail_key)
	player_skills_bar.remove_skill(removed_tail_key)
	
	if tails.size() == 0:
		tail_card1.clear_tail_card()
		return true
	
	if removed_tail_key == 0:
		tail_card1.clear_tail_card()
		tail_card1.prepare_tail_card(tail_card2.tail_data)
		if tail_card3.tail_data != null:
			tail_card2.prepare_tail_card(tail_card3.tail_data)
		else:
			tail_card2.clear_tail_card()
	
	elif removed_tail_key == 1:
		tail_card2.clear_tail_card()
		if tail_card3.tail_data != null:
			tail_card2.prepare_tail_card(tail_card3.tail_data)
	
	tail_card3.clear_tail_card()
