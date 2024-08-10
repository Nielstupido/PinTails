extends Area3D


var bullet_speed = 50.0
var damage : int


func _on_Bullet_body_entered(body):
	print("body hit == " + str(body.name))
	if body.is_in_group("Player"):
		body.on_player_hit(self.damage)
		self.queue_free()


func setup_bullet(starting_transform : Transform3D, new_damage : int):
	self.global_transform = starting_transform
	self.damage = new_damage


func _process(delta):
	global_transform.origin -= global_transform.basis.z * bullet_speed * delta
