extends Node3D


@onready var tower_obj = preload("res://Scenes/Tails/Meerkat/Tower.tscn")
@onready var raycast = get_parent()


func _ready():
	self.global_transform.origin = raycast.get_collision_point()


func _input(event):
	if event.is_action_pressed("action_primary"):
		var tower = tower_obj.instantiate()
		GAMEPLAYMANAGER.game_node.add_child(tower)
		tower.setup_tower(self.global_transform.origin)
		self.queue_free()


func _process(delta):
	self.global_transform.origin = raycast.get_collision_point()
	self.global_rotation = raycast.owner.rotation
