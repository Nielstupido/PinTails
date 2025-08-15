extends TailSkill


@onready var spawn_point = $"../../Neck/Head/SkillAttachments/PunchStart"
var fist_obj_path = "res://Scenes/Tails/MantisShrimp/Fist.tscn"
var stun_range : int


func _on_wall_hit(body) -> void:
	if body.is_in_group("Wall") or body.is_in_group("Floor"):
		print(" HIT!! --> " + str(body))


func _input(event) -> void:
	if event.is_action_pressed("playerhand|action_primary") and _is_activated:
		var var_dict = {"camera_collision" : owner.player_interaction_component.get_camera_collision(15)}
		get_tree().root.get_node("Game").get_map_node().spawner.rpc(
				"spawn_object",
				spawn_point.get_path(),
				fist_obj_path,
				var_dict,
				)
		stop_skill()


#Override this function
func _execute_skill(range : int) -> void:
	if _is_activated:
		return
	
	_is_activated = true
	stun_range = range
	_skill_card_node.activate_skill(self, true, false, true, _skill_card_node.tail_data.skill_duration)


#Override this function
func stop_skill() -> void:
	_skill_card_node.start_cooldown()
	_is_activated = false
