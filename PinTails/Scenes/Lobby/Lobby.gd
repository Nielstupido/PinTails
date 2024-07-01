extends Control


onready var tail_card_holder = $TailCardsHolder
var tail_res_folder = "res://Scenes/Tails/"
var tail_data_list : Array


func _ready():
	self.hide()
	var dir = Directory.new()
	if dir.open(tail_res_folder) == OK:
		for tail_name in GAME.tail_names:
			if dir.file_exists(tail_res_folder + "%s/%s.tres" % [tail_name, tail_name]):
				tail_data_list.append((ResourceLoader.load(tail_res_folder + "%s/%s.tres" % [tail_name, tail_name])).get_tail_data())
			else:
				tail_data_list.append(TailData.new())
	else:
		OS.alert("Game files not found! \nRestart Game", "ERROR")
		get_tree().quit()


func open_lobby():
	self.show()
	get_child(1).prepare_tail_cards(tail_data_list)


func _on_StartMatch_pressed():
	var _error = get_tree().change_scene("res://Scenes/Game/Game.tscn")


func _on_LeaveLobby_pressed():
	self.hide()
