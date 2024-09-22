extends Node


func execute_skill(dash_rate : int):
	owner.DASH_LERP_SPEED = Vector3(dash_rate, 1.0, dash_rate)
	owner.is_dashing = true
