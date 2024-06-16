extends Node

signal weapon_picked_up(weapon_id)

var gun_id


func _ready():
	gun_id = 0 


func get_gun_id() -> int:
	gun_id += 1 
	return gun_id
