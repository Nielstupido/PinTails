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
