class_name MapTest
extends Node


@onready var tail_obj = preload("res://Scenes/Tails/Tail.tscn")
const SPAWN_RANDOM := 5.0

#<-------For testing-------->
var tail_res_folder = "res://Scenes/Tails/"
var tail_data_list : Array
#<-------For testing-------->	


func _ready():    
	multiplayer.server_relay = true
	GAMEPLAYMANAGER.map_node = self
	print("Map ready")
	
	if not multiplayer.is_server():
		return 
	
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)
	#if GAMEPLAYMANAGER.local_host_mode && not OS.has_feature("dedicated_server"):
	if GAMEPLAYMANAGER.server_mode_selected && not OS.has_feature("dedicated_server"):
		add_player(1)
	
##<-------For testing-------->
	var randomZ = RandomNumberGenerator.new()
	var dir = DirAccess.open(tail_res_folder)
	
	for tail_class in Tail.Classes.keys():
		tail_class = STRINGHELPER.filter_string(tail_class, true, "_")
		if dir.file_exists(tail_res_folder + "%s/%s.tres" % [tail_class, tail_class]):
			var tail_data =  ResourceLoader.load(tail_res_folder + "%s/%s.tres" % [tail_class, tail_class]).get_tail_data()
			tail_data_list.append(tail_data)
	for tail_data in tail_data_list:
		var tail_pos = Vector3.ZERO
		tail_pos.z = randomZ.randf_range(-6, 6)
		spawn_tail(tail_pos, tail_data.stringify())
##<-------For testing-------->


@rpc("any_peer", "call_local", "reliable")
func spawn_tail(spawn_pos : Vector3, tail_data_bytes : String) -> void:
	if multiplayer.is_server():
		var tail_instance = tail_obj.instantiate()
		tail_instance.position = spawn_pos
		tail_instance.tail_data_bytes = tail_data_bytes
		$WorldItems.add_child(tail_instance, true)


func add_player(id: int):
	print("Add player: " + str(id))
	var character = preload("res://Scenes/Characters/Player.tscn").instantiate()
	
	var rng = RandomNumberGenerator.new()
	var random_x = rng.randf_range(10.0, 15.0)
	var random_z = rng.randf_range(10.0, 20.0)
	character.position = Vector3(random_x, 10, random_z)
	 
	character.name = str(id)
	$PlayerNodes.add_child(character, true)


func del_player(id: int):
	if not $PlayerNodes.has_node(str(id)):
		return
	$PlayerNodes.get_node(str(id)).queue_free()


func _exit_tree():
	if multiplayer.peer_connected.is_connected(add_player):
		multiplayer.peer_connected.disconnect(add_player)
	if multiplayer.peer_disconnected.is_connected(del_player):
		multiplayer.peer_disconnected.disconnect(del_player)
