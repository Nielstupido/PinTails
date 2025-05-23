class_name Weapon_old
extends RigidBody3D


@export var drop_scale : float
var id : int


func _ready():
	GameplayManager.weapon_picked_up.connect(_weapon_picked_up)
	
	if self.owner:
		if self.owner.is_in_group("Player"):
			id = -1
	
	if self.get_parent().name == "Game":
		self.scale = (Vector3.ONE * drop_scale)


func _weapon_picked_up(picked_up_id):
	if picked_up_id == self.id:
		self.queue_free()
