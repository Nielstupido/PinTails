extends Control


func toggle_motion_blur(switch : bool) -> void:
	get_child(0).get_material().set_shader_parameter("is_active", switch)
