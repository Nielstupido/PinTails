@tool
extends Node


signal weapon_picked_up(weapon_id)
signal tail_picked_up(tail_data)
signal tail_removed(tail_data, removed_tail_key)

const GAME_SCENE = "res://Scenes/Game/Game.tscn"
const MAIN_MENU_SCENE = "res://Scenes/MainMenu/MainMenu.tscn"
#const GAME_OVER_SCENE = "res://scenes/game_over.tscn"

# NOTE: Manually set this to true before running, if you want one of the debug clients to also run 
# on the server instance (host).
@export var local_host_mode: bool = true
@export var server_mode_selected: bool = true
@export var selected_map: String = "res://Scenes/Game/Map/MapTest.tscn" # This could be something that the player selects

var map_node : Node
var _gun_id
var _tail_id
var tail_res : Resource


func _ready():
	pass


func load_game_play_scene():
	get_tree().call_deferred(&"change_scene_to_packed", preload(GAME_SCENE))


func load_main_menu_scene():
	get_tree().call_deferred(&"change_scene_to_packed", preload(MAIN_MENU_SCENE))


#func load_game_over_scene():
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # make sure we free up mouse to allow button interaction
	#get_tree().call_deferred(&"change_scene_to_packed", preload(GAME_OVER_SCENE))

