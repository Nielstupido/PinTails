extends Node3D


@onready var spawn_point = $"../../Neck/Head/SkillAttachments/PunchStart"
var fist_obj_path = "res://Scenes/Tails/MantisShrimp/Fist.tscn"
var stun_range : int


func _on_wall_hit(body) -> void:
	if body.is_in_group("Wall") or body.is_in_group("Floor"):
		print(" HIT!! --> " + str(body))


func execute_skill(range : int) -> void:
	stun_range = range
	var var_dict = {"camera_collision" : get_camera_collision()}
	get_tree().root.get_node("Game/Map/MapTest").spawner.rpc(
			"spawn_object", 
			spawn_point.get_path(),
			fist_obj_path,
			var_dict)


func get_camera_collision() -> Vector3:
	var viewport = get_viewport().get_size()
	var camera = get_viewport().get_camera_3d()
	
	var Ray_Origin = camera.project_ray_origin(viewport/2)
	var Ray_End = Ray_Origin + camera.project_ray_normal(viewport/2) * 15
	
	var New_Intersection = PhysicsRayQueryParameters3D.create(Ray_Origin,Ray_End)
	var Intersection = owner.player_interaction_component.get_world_3d().direct_space_state.intersect_ray(New_Intersection)
	
	if not Intersection.is_empty():
		var Col_Point = Intersection.position
		return Col_Point
	else:
		return Ray_End 
