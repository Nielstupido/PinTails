extends Node3D

@onready var skill_animation_player = $"../SkillAnimationsPlayer"
@onready var spawn_point = $"../../Neck/Head/SkillAttachments/ProjectileStartingPoint"
var projectile_obj_path = "res://Scenes/Tails/Scorpion/PoisonSpill.tscn"
var is_skill_triggered = false
var stab_damage : int


func _input(event) -> void:
	if event.is_action_pressed("action_primary") and is_skill_triggered:
		skill_animation_player.play("poison_stab")


func _on_enemy_hit(body) -> void: 
	if body.is_in_group("Player") and body != owner:
		#body.take_damage(stab_damage)
		print("ENEMY HIT!! ----> " + str(body))
 

func execute_skill(damage : int) -> void:
	stab_damage = damage
	is_skill_triggered = true
	
	get_tree().root.get_node("Game/Map/MapTest").spawner.rpc(
			"spawn_object", 
			spawn_point.get_path(),
			projectile_obj_path,
			"camera_collision",
			get_camera_collision())


func skill_timeout() -> void:
	is_skill_triggered = false


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
