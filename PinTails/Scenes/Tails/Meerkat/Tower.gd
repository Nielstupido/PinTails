extends Node3D
 

signal vision_stopped()
var vision_duration : int = 20


func _ready():
	$AnimationPlayer.play("arise")
	await get_tree().create_timer(vision_duration).timeout 
	$AnimationPlayer.play("hide")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hide":
		_set_enemy_mesh_default()
		queue_free()


func _on_vision_area_body_entered(body):
	if body.is_in_group("Player"):
		body.set_mesh_transparent(self)
		print("Enemy Detected! " + str(body.name))


func _set_enemy_mesh_default() -> void:
	emit_signal("vision_stopped")
