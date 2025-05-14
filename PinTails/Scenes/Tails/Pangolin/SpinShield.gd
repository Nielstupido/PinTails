extends TailSkill


#Override this function
func _execute_skill(dash_rate : int) -> void:
	owner.is_dmg_immuned = true
	owner.dash_rate = Vector3(dash_rate, 1.0, dash_rate)
	owner.dash_length = 500
	owner.dash_lerp_speed = 0.02
	owner.is_dashing = true
