extends Node3D


@onready var spawn_point = $"../../Neck/Head/SkillAttachments/PunchStart"
var fist_obj_path = "res://Scenes/Tails/MantisShrimp/Fist.tscn"
var stun_range : int


func _on_wall_hit(body) -> void:
	if body.is_in_group("Wall") or body.is_in_group("Floor"):
		print(" HIT!! --> " + str(body))


func execute_skill(range : int) -> void:
	stun_range = range
	var var_dict = {"camera_collision" : owner.player_interaction_component.get_camera_collision(15)}
	get_tree().root.get_node("Game/Map/MapTest").spawner.rpc(
			"spawn_object", 
			spawn_point.get_path(),
			fist_obj_path,
			var_dict)
