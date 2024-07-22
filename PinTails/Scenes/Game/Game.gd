extends Node


onready var tail_obj = preload("res://Scenes/Tails/Tail.tscn")
onready var tail_pos = $TailDropPoint


#<-------For testing-------->
var tail_res_folder = "res://Scenes/Tails/"
var tail_data_list : Array
#<-------For testing-------->


func _ready():
	for node in get_children():
		print(node.name)
	
#<-------For testing-------->
	var randomZ = RandomNumberGenerator.new()
	var dir = Directory.new()
	for tail_name in GAMEMANAGER.tail_names:
		if dir.file_exists(tail_res_folder + "%s/%s.tres" % [tail_name, tail_name]):
			tail_data_list.append((ResourceLoader.load(tail_res_folder + "%s/%s.tres" % [tail_name, tail_name])).get_tail_data())
	
	for tail_data in tail_data_list:
		var tail_instance = tail_obj.instance()
		tail_instance.global_transform = tail_pos.global_transform
		tail_instance.global_translation.z = randomZ.randf_range(-6, 6)
		tail_instance.id = GAMEMANAGER.get_tail_id()
		tail_instance.prepare_tail(tail_data)
		GAMEMANAGER.get_node(".").add_child(tail_instance)
#<-------For testing-------->
