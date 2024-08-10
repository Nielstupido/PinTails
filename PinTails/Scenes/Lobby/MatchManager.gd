class_name MatchManager
extends Node


signal on_player_selected_tail(player_name, tail_data)
const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"
@onready var lobby_scene = load("res://Scenes/Lobby/Lobby.tscn")
var match_id : int
var match_players : Dictionary # {player_name : player_role}
var player_name : String


# <------ for offline testing ------>

var player_id = 1

# <------ for offline testing ------>


func _find_match():
	_on_match_found(
		1,
		{
			"test1" : null,
			"test2" : null,
			player_name : null,
			"test3" : null,
			"test4" : null
		}
	)


func _on_match_found(new_match_id, new_players):
	match_players = new_players
	match_id = new_match_id
	get_tree().change_scene_to_packed(lobby_scene)


func host_game():
	pass
#	var server_peer = ENet


func player_selected_tail(player_name, tail_data):
	self.emit_signal("on_player_selected_tail", player_name, tail_data)


func start_matchmaking(this_player_name):
	player_name = this_player_name
	_find_match()
