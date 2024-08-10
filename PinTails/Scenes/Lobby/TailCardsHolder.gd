extends Control


signal on_tail_card_pressed(tail_data)
@onready var tail_card_holder = preload("res://Scenes/Lobby/TailCardLobby.tscn")
@onready var cards_container = $GridContainter


func prepare_tail_cards(tail_cards):
	var new_card
	for tail_data in tail_cards:
		print(tail_data.tail_name)
		new_card = tail_card_holder.instantiate()
		cards_container.add_child(new_card)
		new_card.prepare_tail_card(tail_data)
