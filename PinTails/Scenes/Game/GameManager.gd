extends Node


signal weapon_picked_up(weapon_id)
signal tail_picked_up(tail_id)

var gun_id
var tail_id
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
	gun_id = 0
	tail_id = 0


func get_gun_id() -> int:
	gun_id += 1
	return gun_id


func get_tail_id() -> int:
	tail_id += 1
	return tail_id


func get_tail_dets():
	pass
