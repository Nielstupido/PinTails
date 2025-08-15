extends TailSkill


@onready var tower_positioner_obj = preload("res://Scenes/Tails/Meerkat/TowerPositioner.tscn")


func _input(event):
	if owner.is_multiplayer_authority() and _is_activated:
		if event.is_action_pressed("playerhand|action_primary"):
			print("skill node " + str(_skill_card_node))
			_skill_card_node.start_cooldown()
			_is_activated = false


#Override this function
func _execute_skill(value : int) -> void:
	if owner.interaction_raycast.get_child_count() == 0:
		_skill_card_node.toggle_hotkey_cover(true)
		var tower_pos = tower_positioner_obj.instantiate()
		owner.interaction_raycast.add_child(tower_pos)
		_is_activated = true
	else:
		_skill_card_node.toggle_hotkey_cover(false)
		owner.interaction_raycast.get_child(0).queue_free()
		_is_activated = false
