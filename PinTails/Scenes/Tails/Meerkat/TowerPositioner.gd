extends Node3D


@onready var raycast = get_parent()
var tower_scene_path = "res://Scenes/Tails/Meerkat/Tower.tscn"


func _ready():
	self.global_transform.origin = raycast.get_collision_point()


func _input(event):
	if event.is_action_pressed("playerhand|action_primary"):
		get_tree().root.get_node("Game").get_map_node().spawner.rpc(
				"spawn_object", 
				global_transform, 
				tower_scene_path,
				{})
		
		self.queue_free()


func _process(delta):
	self.global_transform.origin = raycast.get_collision_point()
	self.global_rotation = raycast.owner.rotation
