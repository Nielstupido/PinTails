extends Node


signal weapon_picked_up(weapon_id)
signal tail_picked_up(tail_data)

var game_node : Game
var _gun_id
var _tail_id
var tail_res : Resource

var tail_names = [
	"Scorpion",
	"Cheetah",
	"Gecko",
	"Rhino",
	"Pangolin",
	"Panther",
	"Chameleon",
	"Meerkat",
	"Mantis Shrimp",
	"Monkey"
]


func _ready():
	_gun_id = 0
	_tail_id = 0


func get_gun_id() -> int:
	_gun_id += 1
	return _gun_id


func get_tail_id() -> int:
	_tail_id += 1
	print("gun id given = " + str(_tail_id) )
	return _tail_id


func get_tail_dets():
	pass
