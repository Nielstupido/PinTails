extends RigidBody3D


var projectile_velocity = 50
var camera_collision : Vector3 :
	set(value):
		if value == Vector3.ZERO:
			return
		
		var direction = (value - get_parent().get_global_transform().origin).normalized()
		set_linear_velocity(direction * projectile_velocity)


func _on_body_entered(body): 
	if body.is_in_group("Ground") or body.is_in_group("Wall"):
		self.freeze = true
		$MeshInstance3D.hide()
		$StunEffectPlayer.play("stun_effect")


func _on_stun_effect_player_animation_finished(_anim_name):
	get_tree().root.get_node("Game/Map/MapTest").spawner.rpc("remove_obj",  self.get_path(), is_multiplayer_authority())
