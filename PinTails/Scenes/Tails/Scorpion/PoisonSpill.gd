extends RigidBody3D


var projectile_velocity = 20
var camera_collision : Vector3 :
	set(value):
		var direction = (value - get_parent().get_global_transform().origin).normalized()
		set_linear_velocity(direction * projectile_velocity)


func _on_body_entered(body):
	if body.is_in_group("Ground") and $PoisonProjectile.visible:
		$PoisonBubbleEffect.emitting = false
		$PoisonProjectile.visible = false
		$EffectsPlayer.play("poison_spill")


func _on_effects_player_animation_finished(anim_name):
	if anim_name == "poison_spill":
		get_tree().root.get_node("Game/Map/MapTest").spawner.rpc("remove_obj",  self.get_path(), is_multiplayer_authority())
