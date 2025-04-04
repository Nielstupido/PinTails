extends Node3D


func execute_skill(concealment_length : int) -> void:
	owner.is_player_invisible = true
	owner.invi_screen_effect.toggle_invi_effect(true);
	owner.body.mesh.material.set_albedo(Color(owner.body.mesh.material.get_albedo().r, owner.body.mesh.material.get_albedo().g, owner.body.mesh.material.get_albedo().b, 0))
	await get_tree().create_timer(concealment_length).timeout
	owner.body.mesh.material.albedo_color.a = 1.0
	owner.invi_screen_effect.toggle_invi_effect(false);
	owner.is_player_invisible = false
