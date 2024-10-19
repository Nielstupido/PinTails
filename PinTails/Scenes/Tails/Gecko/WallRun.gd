extends Node3D


var is_skill_enabled = true
var is_on_wall = false
var last_collided_wall = null


func execute_skill(damage : int) -> void:
	is_skill_enabled = true


func _process(_delta) -> void: 
	if is_skill_enabled: 
		if owner.interaction_raycast.is_colliding():
			if owner.interaction_raycast.get_collider().is_in_group("Wall"):
				last_collided_wall = owner.interaction_raycast.get_collider()
				last_collided_wall.get_parent().mesh.material.set_albedo(Color(1,1,0.5,1))
		else:
			if last_collided_wall:
				last_collided_wall.get_parent().mesh.material.set_albedo(Color(1,1,1,1))


func _input(event) -> void:
	if event.is_action_pressed("skill_trigger_primary"):
		is_skill_enabled = false
	elif event.is_action_pressed("skill_trigger_secondary"):
		if owner.interaction_raycast.is_colliding():
			if owner.interaction_raycast.get_collider().is_in_group("Wall"):
				owner.on_wall_run = true
				stick_to_wall()


func stick_to_wall() -> void:
	owner.global_transform.origin = owner.interaction_raycast.get_collision_point()
