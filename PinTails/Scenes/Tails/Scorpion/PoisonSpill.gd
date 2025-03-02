extends RigidBody3D


@export var camera_collision : Vector3
var projectile_velocity = 20.0


func _ready():
	var Direction = (camera_collision - get_global_transform().origin).normalized()
	set_linear_velocity(Direction * projectile_velocity)


func _on_body_entered(body):
	if body.name == "Ground" and $PoisonProjectile.visible:
		$PoisonProjectile.visible = false
		$PoisonSpill.emitting = true
