extends Node3D
 

signal vision_stopped()
var vision_duration : int = 6
var debris_albedo 


func _ready():
	debris_albedo = $RockParticleSystem.material_override.get_albedo()
	$RockParticleSystem.material_override.set_albedo(Color(debris_albedo.r, debris_albedo.g, debris_albedo.b, 1.0))
	$AnimationPlayer.play("rise")
	$RockParticleSystem.restart()
	await get_tree().create_timer(vision_duration).timeout 
	$AnimationPlayer.play("hide") 
	$AnimationPlayerDebris.play("hide_debris") 
	create_tween().tween_property($RockParticleSystem,"material_override:albedo_color:a", 0.0, 0.5)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "rise":
		$RockParticleSystem.emitting = false
	
	if anim_name == "hide":
		$RockParticleSystem.restart()
		$AnimationPlayerDebris.play("RESET")
		$AnimationPlayer.play("RESET")
		_set_enemy_mesh_default()
		get_tree().root.get_node("Game").get_map_node().spawner.rpc("remove_obj",  self.get_path(), is_multiplayer_authority())


func _on_vision_area_body_entered(body):	if body.is_in_group("Player"):
		body.set_mesh_transparent(self)
		print("Enemy Detected! " + str(body.name))


func _set_enemy_mesh_default() -> void:
	emit_signal("vision_stopped")
