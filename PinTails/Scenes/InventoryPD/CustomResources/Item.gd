class_name Item
extends RigidBody3D

@export var weapon_data : WeaponData = null
@export var action_keyword : String
var interaction_text : String 
var item_data_bytes : String
var tail_data : TailData = null

 
func _ready():
	interaction_text = "Press " + str(OS.get_keycode_string((InputMap.action_get_events(action_keyword))[0].keycode)) + " to pick up"
	_on_multiplayer_synchronizer_synchronized()


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
