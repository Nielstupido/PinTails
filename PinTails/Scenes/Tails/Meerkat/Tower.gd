extends Node3D
 

signal vision_stopped()
const EMPTY = ""
var vision_duration : int = 15
var debris_albedo 
var skill_owner : String = EMPTY
var is_skill_active = false
var enemies_detected = []


func _ready():
	debris_albedo = $RockParticleSystem.material_override.get_albedo()
	$RockParticleSystem.material_override.set_albedo(Color(debris_albedo.r, debris_albedo.g, debris_albedo.b, 1.0))
	is_skill_active = true
	_apply_material_to_enemies()
	$AnimationPlayer.play("rise")
	$RockParticleSystem.restart()
	await get_tree().create_timer(vision_duration).timeout 
	is_skill_active = false
	$AnimationPlayer.play("hide") 
	$AnimationPlayerDebris.play("hide_debris") 
	create_tween().tween_property($RockParticleSystem,"material_override:albedo_color:a", 0.0, 0.5)


func _on_animation_player_animation_finished(anim_name):
	skill_owner = EMPTY
	
	if anim_name == "rise":
		$RockParticleSystem.emitting = false
	
	if anim_name == "hide":
		$RockParticleSystem.restart()
		$AnimationPlayerDebris.play("RESET")
		$AnimationPlayer.play("RESET")
		get_tree().root.get_node("Game").get_map_node().spawner.rpc("remove_obj",  self.get_path(), is_multiplayer_authority())


func _on_vision_area_body_entered(body):
	if skill_owner != EMPTY:
		if body.is_in_group("Player") and body.name != skill_owner and not enemies_detected.has(body):
			enemies_detected.append(body)
			print("Enemy Detected! " + str(body.name))


func _on_vision_area_body_exited(body):
	if enemies_detected.has(body):
		enemies_detected.remove_at(enemies_detected.find(body))


func _apply_material_to_enemies():
	for enemy in enemies_detected:
		enemy.rpc("apply_vision_material")
	
	await get_tree().create_timer(3.0).timeout
	if is_skill_active:
		_apply_material_to_enemies()
