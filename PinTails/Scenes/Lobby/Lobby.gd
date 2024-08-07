extends Control


onready var main_menu_scene = load("res://Scenes/MainMenu/MainMenu.tscn")
onready var tail_cards_holder = $TailCardsHolder
onready var player_cards_holder = $Players/PlayerCardsHolder
onready var grid_container = $TailCardsHolder/GridContainter
var tail_res_folder = "res://Scenes/Tails/"
var tail_data_list : Array
var current_tail_data : TailData
var match_players : Dictionary
var player_name : String


func _ready():
	match_players = MATCHMANAGER.match_players
	player_name = MATCHMANAGER.player_name
	player_cards_holder
	$StartMatch.disabled = true
	tail_cards_holder.connect("on_tail_card_pressed", self, "_on_tail_card_pressed")
	
	var dir = Directory.new()
	if dir.open(tail_res_folder) == OK:
		for tail_name in GAMEMANAGER.tail_names:
			if dir.file_exists(tail_res_folder + "%s/%s.tres" % [tail_name, tail_name]):
				tail_data_list.append((ResourceLoader.load(tail_res_folder + "%s/%s.tres" % [tail_name, tail_name])).get_tail_data())
			else:
				tail_data_list.append(TailData.new())
		
		tail_cards_holder.prepare_tail_cards(tail_data_list)
	else:
		OS.alert("Game files not found! \nRestart Game", "ERROR")
		get_tree().quit()
	
	for x in 5:
		player_cards_holder.get_child(x).setup_player(match_players.keys()[x])


func _on_StartMatch_pressed():
	MATCHMANAGER.match_players[player_name] = current_tail_data
	var _error = get_tree().change_scene("res://Scenes/Game/Game.tscn")
 

func _on_LeaveLobby_pressed():
	get_tree().change_scene_to(main_menu_scene)


func _on_tail_card_pressed(tail_data):
	if $StartMatch.disabled:
		$StartMatch.disabled = false
	current_tail_data = tail_data
