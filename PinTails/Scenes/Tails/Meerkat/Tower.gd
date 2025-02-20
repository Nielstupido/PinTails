extends Node3D
 

signal vision_stopped()
var vision_duration : int = 6
var debris_albedo 


func _ready():
	$AnimationPlayer.play("arise")
	$RockParticleSystem.emitting = true
	await get_tree().create_timer(vision_duration).timeout 
	$AnimationPlayer.play("hide") 
	$AnimationPlayerDebris.play("hide_debris") 
	debris_albedo = $RockParticleSystem.draw_pass_1.material.get_albedo()
	var tween = get_tree().create_tween();
	tween.tween_method(_set_debris_alpha, 1.0, 0.0, 0.5)


func _set_debris_alpha(value : float):
	$RockParticleSystem.draw_pass_1.material.set_albedo(Color(debris_albedo.r, debris_albedo.g, debris_albedo.b, value))


func _on_animation_player_animation_finished(anim_name):
	$RockParticleSystem.emitting = false
	if anim_name == "hide":
		_set_enemy_mesh_default()
		queue_free()


func _on_vision_area_body_entered(body):
	if body.is_in_group("Player"):
		body.set_mesh_transparent(self)
		print("Enemy Detected! " + str(body.name))


func _set_enemy_mesh_default() -> void:
	emit_signal("vision_stopped")
