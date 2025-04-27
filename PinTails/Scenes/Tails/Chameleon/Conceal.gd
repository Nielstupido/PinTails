extends Node3D


func execute_skill(concealment_length : int) -> void:
	var new_player_color = owner.body.mesh.material.get_albedo()
	new_player_color.a = 0.0
	owner.invi_screen_effect.toggle_invi_effect(true);
	await create_tween().tween_property(owner.body,"mesh:material:albedo_color", new_player_color, 0.4)
	await get_tree().create_timer(concealment_length).timeout
	owner.invi_screen_effect.toggle_invi_effect(false);
	new_player_color = owner.body.mesh.material.get_albedo()
	new_player_color.a = 1.0
	await create_tween().tween_property(owner.body,"mesh:material:albedo_color", new_player_color, 0.4)
