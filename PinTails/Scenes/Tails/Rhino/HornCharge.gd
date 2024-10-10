extends Node3D


func execute_skill(dash_rate : int) -> void:
	owner.dash_rate = Vector3(dash_rate, 1.0, dash_rate)
	owner.dash_length = 100
	owner.dash_lerp_speed = 0.1
	owner.is_dashing = true
