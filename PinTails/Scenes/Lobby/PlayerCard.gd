extends Control


@onready var player_name_text = $VBoxContainer/PlayerIcon/Label
@onready var tail_class_text = $VBoxContainer/SelectedTail/Label


func _ready():
	MATCHMANAGER.connect("on_player_selected_tail", Callable(self, "_on_player_selected_tail"))


func _on_player_selected_tail(player_name, tail_data):
	if player_name == self.player_name_text.text:
		self.set_tail(tail_data.tail_class)


func setup_player(player_name):
	self.player_name_text.text = player_name


func set_tail(tail_class):
	self.tail_class_text.text = STRINGHELPER.filter_string(Tail.Classes.find_key(tail_class))
