extends Node3D


var is_skill_triggered = false


func execute_skill(value : int) -> void:
	is_skill_triggered = true


func skill_timeout() -> void:
	is_skill_triggered = false
