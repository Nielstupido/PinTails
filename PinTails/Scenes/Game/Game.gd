class_name Game
extends Node


signal player_ready_signal


func _ready():
	player_ready_signal.connect(_player_ready)


# Perform any player ready cleanup here
func _player_ready():
	$UI.hide()


func get_map_node():
	return $Map.get_child(0) as Node
