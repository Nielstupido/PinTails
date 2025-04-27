extends Control


@onready var color_rect = $ColorRect


func _ready():
	color_rect.hide()


func toggle_invi_effect(switch) -> void:
	if switch:
		color_rect.material.set_shader_parameter("alpha", 0.0)
		color_rect.show()
		create_tween().tween_property(color_rect,"material:shader_parameter/alpha", 0.4, 0.4)
	else:
		await create_tween().tween_property(color_rect,"material:shader_parameter/alpha", 0.0, 0.4).set_delay(0.1)
		color_rect.hide()
