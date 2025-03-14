class_name Item
extends RigidBody3D

@export var weapon_data : WeaponData = null
@export var action_keyword : String
var item_data_bytes : String
var interaction_text : String 
var tail_data : TailData = null
var is_dropped : bool = false
var projectile_velocity = 3

var starting_point_transform = null : ##Transform3D
	set(value):
		starting_point_transform = value
		_assign_velocity()

var camera_collision = null : ##Vector3
	set(value):
		camera_collision = value
		_assign_velocity()


func _assign_velocity():
	if camera_collision == Vector3.ZERO and !is_dropped:
		return
	
	if starting_point_transform == null or camera_collision == null:
		return
	
	var direction = (camera_collision - starting_point_transform.origin).normalized()
	set_linear_velocity(direction * projectile_velocity)


func _ready():
	interaction_text = "Press " + str(OS.get_keycode_string((InputMap.action_get_events(action_keyword))[0].keycode)) + " to pick up"


func pick_up():
	get_tree().root.get_node("Game/Map/MapTest").spawner.rpc("remove_obj",  self.get_path())


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
			print("<<<<< TAIL DATA PARSE ERR >>>>>")


func _on_multiplayer_synchronizer_synchronized():
	sync_data()
