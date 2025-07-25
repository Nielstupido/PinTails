extends TailSkill


var is_on_wall = false
var last_collided_wall = null


#Override this function
func _execute_skill(duration : int) -> void:
	if not _is_activated:
		_is_activated = true
		_skill_card_node.activate_skill(self, true, false, true, duration)


func _process(_delta) -> void: 
	if _is_activated:
		if owner.is_wallrunning and owner.player_collision_area.has_overlapping_bodies():
			if owner.player_collision_area.get_overlapping_bodies()[0].is_in_group("Wall"):
				last_collided_wall = owner.player_collision_area.get_overlapping_bodies()[0]
				last_collided_wall.get_parent().mesh.material.set_albedo(Color(1,1,0.5,1))
		else:
			if last_collided_wall:
				last_collided_wall.get_parent().mesh.material.set_albedo(Color(1,1,1,1))


func stop_skill() -> void:
	_is_activated = false
	_skill_card_node.start_cooldown()
	
	if last_collided_wall:
		last_collided_wall.get_parent().mesh.material.set_albedo(Color(1,1,1,1))


func skill_timeout() -> void:
	pass
