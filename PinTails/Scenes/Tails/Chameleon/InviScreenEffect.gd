extends Control


@onready var color_rect = $ColorRect


func _ready():
	color_rect.hide()


func toggle_invi_effect(switch) -> void:
	if switch:
		color_rect.material.set_shader_parameter("alpha", 0.0)
		color_rect.show()
		var tween = get_tree().create_tween();
		tween.tween_method(set_shader_value, 0.0, 0.4, 0.8)
	else:
		var tween = get_tree().create_tween();
		tween.tween_method(set_shader_value, 0.4, 0.0, 0.6)
		await get_tree().create_timer(0.6).timeout
		color_rect.hide()


func set_shader_value(value: float):
	color_rect.material.set_shader_parameter("alpha", value);
