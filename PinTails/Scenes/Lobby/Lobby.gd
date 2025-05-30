extends Control


signal on_player_selected_tail(player_name, tail_data)
@onready var main_menu_scene = load("res://Scenes/MainMenu/MainMenu.tscn")
@onready var tail_cards_holder = $TailCardsHolder
@onready var player_cards_holder = $Players/PlayerCardsHolder
@onready var grid_container = $TailCardsHolder/ScrollContainer/GridContainter
var tail_res_folder = "res://Scenes/Tails/"
var tail_data_list : Array
var current_tail_data : TailData
var match_players : Dictionary
var player_name : String


func _ready():
	match_players = MatchManager.match_players
	player_name = PlayerAccount.username
	$StartMatch.disabled = true
	tail_cards_holder.on_tail_card_pressed.connect(_on_tail_card_pressed)
	
	var dir = DirAccess.open(tail_res_folder)
	if dir:
		for tail_class in Tail.Classes.keys():
			tail_class = StringHelper.filter_string(tail_class, true, "_")
			if dir.file_exists(tail_res_folder + "%s/%s.tres" % [tail_class, tail_class]):
				tail_data_list.append((ResourceLoader.load(tail_res_folder + "%s/%s.tres" % [tail_class, tail_class])).get_tail_data())
			else:
				tail_data_list.append(TailData.new())
		
		tail_cards_holder.prepare_tail_cards(tail_data_list)
	else:
		OS.alert("Game files not found! \nRestart Game", "ERROR")
		get_tree().quit()
	 
	for x in 5:
		player_cards_holder.get_child(x).setup_player(match_players.keys()[x])


func _on_StartMatch_pressed():
	MatchManager.match_players[player_name] = current_tail_data
	#var _error = get_tree().change_scene_to_file("res://Scenes/Game/Game.tscn")
	MatchManager.load_game_play_scene()
 

func _on_LeaveLobby_pressed():
	get_tree().change_scene_to_packed(main_menu_scene)


func _on_tail_card_pressed(tail_data):
	if $StartMatch.disabled:
		$StartMatch.disabled = false
	current_tail_data = tail_data
