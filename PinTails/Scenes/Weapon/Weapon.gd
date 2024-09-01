class_name Weapon
extends RigidBody3D

@export var weapon_data : WeaponData
var interaction_text : String


func _ready():
	interaction_text = "Press " + str(OS.get_keycode_string((InputMap.action_get_events("pick_up"))[0].keycode)) + " to pick up"


func pick_up():
	weapon_data.picked_up()
	queue_free()
