class_name Weapon
extends RigidBody


export var drop_scale : float = 1.0
var id : int


func _ready():
	GAMEMANAGER.connect("weapon_picked_up", self, "_weapon_picked_up")
	
	if self.owner:
		if self.owner.is_in_group("Player"):
			id = -1
	
	if self.get_parent().name == "GAME":
		self.scale = (Vector3.ONE * drop_scale)


func _weapon_picked_up(picked_up_id):
	if picked_up_id == self.id:
		self.queue_free()
