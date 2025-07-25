extends TailSkill


#Override this function
func _execute_skill(dash_rate : int) -> void:
	if _is_activated:
		owner.dash_rate = Vector3(dash_rate, 1.0, dash_rate)
		owner.dash_length = 30
		owner.dash_lerp_speed = 0.9
		owner.is_dashing = true
		
		if _skill_card_node.tail_data.skill_type == Skills.Skill_Types.MULTIPLE_TRIGGER:
			_is_activated = _skill_card_node.add_trigger_count()
	else:
		if _skill_card_node.tail_data.skill_type == Skills.Skill_Types.MULTIPLE_TRIGGER:
			_is_activated = true
			_skill_card_node.activate_skill(self) 


#Override this function
func skill_timeout() -> void:
	pass
