extends RigidBody3D


var projectile_velocity = 2
var camera_collision : Vector3 :
	set(value):
		if value == Vector3.ZERO:
			return
		
		var direction = (value - get_parent().get_global_transform().origin).normalized()
		set_linear_velocity(direction * projectile_velocity)


func _on_body_entered(body):
	if body.name == "Ground" or body.name == "Wall":
		$MeshInstance3D.visible = false
