extends TailSkill


var is_skill_triggered = false


#Override this function
func _execute_skill(value : int) -> void:
	is_skill_triggered = true


func skill_timeout() -> void:
	is_skill_triggered = false
