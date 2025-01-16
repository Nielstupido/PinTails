extends Node


var player
var username : String


func setup_player_dets(player_account) -> void:
	player = player_account.user
	username = player.username
