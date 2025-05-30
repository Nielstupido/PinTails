extends CharacterBody3D


@onready var body = $MeshInstance3D


func set_mesh_transparent(node):
	body.get_active_material(0).no_depth_test = true
	node.vision_stopped.connect(_set_mesh_default)


func _set_mesh_default() -> void:
	body.get_active_material(0).no_depth_test = false
