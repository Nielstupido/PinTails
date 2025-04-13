extends Node3D


@onready var tower_positioner_obj = preload("res://Scenes/Tails/Meerkat/TowerPositioner.tscn")


func _input(event):
	if event.is_action_pressed("playerhand|action_primary"):
		pass


func execute_skill(value : int) -> void:
	if owner.interaction_raycast.get_child_count() == 0:
		var tower_pos = tower_positioner_obj.instantiate()
		owner.interaction_raycast.add_child(tower_pos)
	else:
		owner.interaction_raycast.get_child(0).queue_free()
