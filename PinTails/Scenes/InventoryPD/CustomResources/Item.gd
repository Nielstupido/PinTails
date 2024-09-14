class_name Item
extends RigidBody3D

@export var weapon_data : WeaponData = null
@export var action_keyword : String
var tail_data : TailData
var interaction_text : String


func _ready():
	interaction_text = "Press " + str(OS.get_keycode_string((InputMap.action_get_events(action_keyword))[0].keycode)) + " to pick up"


func pick_up():
	if weapon_data != null:
		weapon_data.picked_up()
	queue_free()
