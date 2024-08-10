extends Control


@onready var player_name_text = $VBoxContainer/PlayerIcon/Label
@onready var tail_name_text = $VBoxContainer/SelectedTail/Label


func _ready():
	MATCHMANAGER.connect("on_player_selected_tail", Callable(self, "_on_player_selected_tail"))


func _on_player_selected_tail(player_name, tail_data):
	if player_name == self.player_name_text.text:
		self.set_tail(tail_data.tail_name)


func setup_player(player_name):
	self.player_name_text.text = player_name


func set_tail(tail_name):
	self.tail_name_text.text = tail_name
