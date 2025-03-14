extends Node


@onready var tail_obj = preload("res://Scenes/Tails/Tail.tscn")
@onready var rifle_obj = preload("res://Scenes/Weapon/Rifle/Rifle.tscn")
@onready var pistol_obj = preload("res://Scenes/Weapon/Pistol/Pistol.tscn")
@onready var world_items = $"../WorldItems"
@onready var player_nodes = $"../PlayerNodes"
@onready var obj_spawner = $"../DynamicSpawner"


@rpc("any_peer", "call_local", "reliable")
func spawn_object(node_caller, obj_path : String, var_list : Dictionary) -> void:
	if node_caller is NodePath:
		obj_spawner.spawn_path = node_caller
	
	if multiplayer.is_server():
		var object = load(obj_path) as PackedScene
		var obj_instance = object.instantiate()
		
		if node_caller is NodePath:
			get_node(node_caller).add_child(obj_instance, true)
		else:
			world_items.add_child(obj_instance, true)
			obj_instance.global_transform = node_caller
		
		if var_list:
			for var_name in var_list.keys():
				obj_instance.set(var_name, var_list.get(var_name))


@rpc("any_peer", "call_local", "reliable") 
func spawn_tail(spawn_pos : Vector3, tail_data_bytes : String) -> void:
	if multiplayer.is_server():
		var tail_instance = tail_obj.instantiate()
		world_items.add_child(tail_instance, true)
		tail_instance.position = spawn_pos
		tail_instance.item_data_bytes = tail_data_bytes


@rpc("any_peer", "call_local", "reliable")
func spawn_weapon(node_caller, weapon_type : WEAPONS.Weapon_Types, weapon_data_bytes : String, var_list : Dictionary) -> void:
	if node_caller is NodePath:
		obj_spawner.spawn_path = node_caller
	
	if multiplayer.is_server():
		var weapon_instance
		
		match(weapon_type):
			WEAPONS.Weapon_Types.PISTOL:
				weapon_instance = pistol_obj.instantiate()
			WEAPONS.Weapon_Types.RIFLE:
				weapon_instance = rifle_obj.instantiate()
		
		if weapon_data_bytes == "":
			weapon_data_bytes = weapon_instance.weapon_data.stringify()
		
		if node_caller is NodePath:
			get_node(node_caller).add_child(weapon_instance, true)
		else:
			world_items.add_child(weapon_instance, true)
			weapon_instance.global_transform = node_caller
		
		weapon_instance.item_data_bytes = weapon_data_bytes
	
		if var_list:
			for var_name in var_list.keys():
				weapon_instance.set(var_name, var_list.get(var_name))


@rpc("any_peer", "call_local", "reliable")
func remove_obj(node_path : String):
	if !multiplayer.is_server():
		return
	
	var item = get_node(node_path)
	if item:
		item.queue_free()


func add_player(id: int):
	print("Add player: " + str(id))
	var character = preload("res://Scenes/Characters/Player.tscn").instantiate()
	
	var rng = RandomNumberGenerator.new()
	var random_x = rng.randf_range(10.0, 15.0)
	var random_z = rng.randf_range(10.0, 20.0)
	character.position = Vector3(random_x, 10, random_z)
	 
	character.name = str(id)
	player_nodes.add_child(character, true)


func del_player(id: int):
	if not player_nodes.has_node(str(id)):
		return
	player_nodes.get_node(str(id)).queue_free()
