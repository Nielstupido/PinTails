extends Node


func player_selected_tail(player_name, tail_data):
	self.emit_signal("on_player_selected_tail", player_name, tail_data)
