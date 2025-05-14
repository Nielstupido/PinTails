extends TailSkill


#Override this function
func _execute_skill(dash_rate : int) -> void:
	owner.dash_rate = Vector3(dash_rate, 1.0, dash_rate)
	owner.dash_length = 30
	owner.dash_lerp_speed = 0.9
	owner.is_dashing = true
