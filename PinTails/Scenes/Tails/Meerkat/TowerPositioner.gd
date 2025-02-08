extends Node3D


@onready var tower_scene_path = "res://Scenes/Tails/Meerkat/Tower.tscn"
@onready var raycast = get_parent()


func _ready():
	self.global_transform.origin = raycast.get_collision_point()


func _input(event):
	if event.is_action_pressed("action_primary"):
		get_tree().root.get_node("Game/Map/MapTest").spawner.rpc("spawn_object", self.global_position, tower_scene_path)
		self.queue_free()


func _process(delta):
	self.global_transform.origin = raycast.get_collision_point()
	self.global_rotation = raycast.owner.rotation
