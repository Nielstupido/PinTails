extends TailSkill


var is_skill_triggered = false


#Override this function
func _execute_skill(value : int) -> void:
	if is_skill_triggered:
		return
	
	_skill_card_node.activate_skill(self, true, false, true, _skill_card_node.tail_data.skill_duration)
	is_skill_triggered = true


#Override this function
func stop_skill() -> void:
	_skill_card_node.start_cooldown()
	is_skill_triggered = false
