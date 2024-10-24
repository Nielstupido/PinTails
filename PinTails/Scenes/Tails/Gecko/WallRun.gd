extends Node3D


var is_skill_enabled = false
var is_on_wall = false
var last_collided_wall = null


func execute_skill(duration : int) -> void:
	is_skill_enabled = true
	start_timer(duration)


func start_timer(duration) -> void:
	await get_tree().create_timer(duration).timeout
	is_skill_enabled = false
	
	if last_collided_wall:
		last_collided_wall.get_parent().mesh.material.set_albedo(Color(1,1,1,1))

 
func _process(_delta) -> void: 
	if is_skill_enabled: 
		if owner.is_wallrunning and owner.player_collision_area.has_overlapping_bodies():
			if owner.player_collision_area.get_overlapping_bodies()[0].is_in_group("Wall"):
				last_collided_wall = owner.player_collision_area.get_overlapping_bodies()[0]
				last_collided_wall.get_parent().mesh.material.set_albedo(Color(1,1,0.5,1))
		else:
			if last_collided_wall:
				last_collided_wall.get_parent().mesh.material.set_albedo(Color(1,1,1,1))
