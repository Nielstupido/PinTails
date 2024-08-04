extends Control


onready var main_menu_scene = load("res://Scenes/MainMenu/MainMenu.tscn")
onready var tail_card_holder = $TailCardsHolder
onready var grid_container = $TailCardsHolder/GridContainter
var tail_res_folder = "res://Scenes/Tails/"
var tail_data_list : Array


func _ready():
	var dir = Directory.new()
	if dir.open(tail_res_folder) == OK:
		for tail_name in GAMEMANAGER.tail_names:
			if dir.file_exists(tail_res_folder + "%s/%s.tres" % [tail_name, tail_name]):
				tail_data_list.append((ResourceLoader.load(tail_res_folder + "%s/%s.tres" % [tail_name, tail_name])).get_tail_data())
			else:
				tail_data_list.append(TailData.new())
		
		tail_card_holder.prepare_tail_cards(tail_data_list)
	else:
		OS.alert("Game files not found! \nRestart Game", "ERROR")
		get_tree().quit()
	


func _on_StartMatch_pressed():
	var _error = get_tree().change_scene("res://Scenes/Game/Game.tscn")
 

func _on_LeaveLobby_pressed():
	get_tree().change_scene_to(main_menu_scene)
