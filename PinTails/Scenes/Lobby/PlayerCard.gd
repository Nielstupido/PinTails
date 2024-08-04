extends Control


onready var player_name_text = $VBoxContainer/PlayerIcon/Label.text
onready var tail_name_text = $VBoxContainer/SelectedTail/Label.text
var player_id : int


func setup_player(player_name, id):
	self.player_name_text = player_name
	self.player_id = id


func set_tail(tail_name):
	self.tail_name_text = tail_name
