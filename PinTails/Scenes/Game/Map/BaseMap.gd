class_name BaseMap
extends Node


const SPAWN_RANDOM := 5.0
@onready var spawner = $Spawner
@onready var gameplay_handler = $GameplayHandler

#<-------For testing-------->
var tail_res_folder = "res://Scenes/Tails/"
var tail_data_list : Array
#<-------For testing-------->	


func _ready():    
	multiplayer.server_relay = true
	GameplayManager.map_node = self
	print("Map ready")
	
	if not multiplayer.is_server():
		return 
	
	multiplayer.peer_connected.connect(spawner.add_player)
	multiplayer.peer_disconnected.connect(spawner.del_player)
	#if GameplayManager.local_host_mode && not OS.has_feature("dedicated_server"):
	if GameplayManager.server_mode_selected && not OS.has_feature("dedicated_server"):
		spawner.add_player(1)
	 
##<-------For testing-------->
	var randomZ = RandomNumberGenerator.new()
	var dir = DirAccess.open(tail_res_folder)
	
	for tail_class in Tail.Classes.keys():
		if tail_class == "Mantis_Shrimp" || tail_class == "Meerkat" || tail_class == "Chameleon":
			tail_class = StringHelper.filter_string(tail_class, true, "_")
			if dir.file_exists(tail_res_folder + "%s/%s.tres" % [tail_class, tail_class]):
				var tail_data =  ResourceLoader.load(tail_res_folder + "%s/%s.tres" % [tail_class, tail_class]).get_tail_data()
				tail_data_list.append(tail_data)
	
	for tail_data in tail_data_list:
		var tail_pos = Vector3.ZERO
		tail_pos.z = randomZ.randf_range(-6, 6)
		spawner.spawn_tail(tail_pos, tail_data.stringify())
	
	var equipment_transform = Transform3D(Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO)
	equipment_transform.origin.y += 5.0
	spawner.spawn_weapon(equipment_transform, Weapons.Weapon_Types.PISTOL, "", {})
##<-------For testing-------->


func _exit_tree():
	if multiplayer.peer_connected.is_connected(spawner.add_player):
		multiplayer.peer_connected.disconnect(spawner.add_player)
	if multiplayer.peer_disconnected.is_connected(spawner.del_player):
		multiplayer.peer_disconnected.disconnect(spawner.del_player)
