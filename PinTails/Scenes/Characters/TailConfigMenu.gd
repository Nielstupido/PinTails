extends Control

@onready var tail_card1 = $HBoxContainer/TailMenuHolder/TailCard
@onready var tail_card2 = $HBoxContainer/TailMenuHolder2/TailCard
@onready var tail_card3 = $HBoxContainer/TailMenuHolder3/TailCard
var tails : Array


func _ready():
	GameplayManager.tail_picked_up.connect(add_tail)


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
	removed_tail_key = tails.find(tail_data)
	tails.erase(tail_data)
	GameplayManager.emit_signal("tail_removed", tail_data, removed_tail_key)
	
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
