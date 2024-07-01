extends Control


onready var title_node = $Control/Title
onready var attribs_node = $Control/Atrribs
var tail_data


func prepare_tail_card(passed_tail_data):
	self.tail_data = passed_tail_data
	self.title_node.text = self.tail_data.tail_name
	self.attribs_node.text = self.tail_data.tail_attribs_str


func _on_Button_pressed():
	print(self.tail_data.tail_name)
	LOBBYMANAGER.player_roles[LOBBYMANAGER.player_id] = self.tail_data
