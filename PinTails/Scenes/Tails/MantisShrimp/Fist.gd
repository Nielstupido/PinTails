extends RigidBody3D


var projectile_velocity = 50
var camera_collision : Vector3 :
	set(value):
		if value == Vector3.ZERO:
			return
		
		var direction = (value - get_parent().get_global_transform().origin).normalized()
		set_linear_velocity(direction * projectile_velocity)
		look_at(global_transform.origin + direction)
		print("rotation = " + str(global_rotation))
		print("rotation = " + str(get_parent().global_rotation))


func _on_body_entered(body): 
	if body.is_in_group("Ground") or body.is_in_group("Wall"):
		self.freeze = true
		$MeshInstance3D.hide()
		$StunEffectPlayer.play("stun_effect")


func _on_stun_effect_player_animation_finished(_anim_name):
	get_tree().root.get_node("Game").get_map_node().spawner.rpc("remove_obj",  self.get_path(), is_multiplayer_authority())


func _on_stun_area_body_entered(body):
	if body.is_in_group("Player"):
		if self.get_parent().owner.name != body.name:
			get_tree().root.get_node("Game").get_map_node().gameplay_handler.rpc.call("player_took_damage", body.name)
