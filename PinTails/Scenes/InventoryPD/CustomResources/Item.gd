class_name Item
extends RigidBody3D

@export var weapon_data : WeaponData = null
@export var action_keyword : String
var interaction_text : String 
var tail_data : TailData = null
var is_dropped : bool = false
var projectile_velocity = 3
var item_data_bytes : String = "":
	set(value):
		item_data_bytes = value
		if item_data_bytes != "":
			sync_data()

var starting_point_transform = null : ##Transform3D
	set(value):
		starting_point_transform = value
		_assign_velocity()

var camera_collision : Vector3 = Vector3.ZERO :
	set(value):
		camera_collision = value
		_assign_velocity()


func _assign_velocity(): 
	if camera_collision == Vector3.ZERO or !is_dropped or starting_point_transform == null:
		return
	
	var direction = (camera_collision - starting_point_transform.origin).normalized()
	set_linear_velocity(direction * projectile_velocity)

 
func _ready():
	interaction_text = "Press " + str(OS.get_keycode_string((InputMap.action_get_events("player|" + action_keyword))[0].keycode)) + " to pick up"


func pick_up():
	get_tree().root.get_node("Game").get_map_node().spawner.rpc("remove_obj",  self.get_path(), is_multiplayer_authority())


func sync_data():
	if tail_data == null and weapon_data == null:
		var json = JSON.new()
		var err = json.parse(item_data_bytes)
		
		if err == OK:
			if "tail" in json.data.keys()[json.data.size() - 1]:
				tail_data = TailData.new() 
				tail_data.set_string_to_data(json.data)
			else:
				weapon_data = WeaponData.new()
				weapon_data.set_string_to_data(json.data) 
		else:
			printerr("<<<<< TAIL DATA PARSE ERR >>>>>")
