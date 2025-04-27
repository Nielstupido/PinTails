extends Node3D

@onready var skill_animation_player = $"../SkillAnimationsPlayer"
@onready var spawn_point = $"../../Neck/Head/SkillAttachments/ProjectileStartingPoint"
var projectile_obj_path = "res://Scenes/Tails/Scorpion/PoisonSpill.tscn"
var is_skill_triggered = false
var stab_damage : int


func _input(event) -> void:
	if event.is_action_pressed("playerhand|action_primary") and is_skill_triggered:
		skill_animation_player.play("poison_stab")


func _on_enemy_hit(body) -> void: 
	if body.is_in_group("Player") and body != owner:
		#body.take_damage(stab_damage)
		print("ENEMY HIT!! ----> " + str(body))
 

func execute_skill(damage : int) -> void:
	stab_damage = damage
	is_skill_triggered = true
	
	var var_dict = {"camera_collision" : owner.player_interaction_component.get_camera_collision(15)}
	
	get_tree().root.get_node("Game").get_map_node().spawner.rpc(
			"spawn_object", 
			spawn_point.get_path(),
			projectile_obj_path,
			var_dict)


func skill_timeout() -> void:
	is_skill_triggered = false
