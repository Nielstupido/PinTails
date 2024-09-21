extends Node3D


@onready var skill_animation_player = $AnimationPlayer


func execute_skill():
	skill_animation_player.play("poison_stab")


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(10)
