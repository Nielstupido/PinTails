extends Control


func toggle_motion_blur(switch : bool) -> void:
	$ImpactMotionBlur.get_material().set_shader_parameter("is_active", switch)


func toggle_motion_lines(switch : bool) -> void:
	$FastMotionLines.get_material().set_shader_parameter("is_active", switch)
