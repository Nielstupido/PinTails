class_name Gun
extends Spatial


var id : int
var pistol_scale = Vector3.ONE * 0.03
var rifle_scale = Vector3.ONE * 0.071


func _ready():
	GAME.connect("weapon_picked_up", self, "_weapon_picked_up")
	
	if self.owner:
		if self.owner.is_in_group("Player"):
			id = -1
	
	if self.get_parent().name == "GAME":
		if self.name == "Pistol":
			self.scale = pistol_scale
		elif self.name == "Rifle":
			self.scale = rifle_scale


func _weapon_picked_up(picked_up_id):
	if picked_up_id == self.id:
		self.queue_free()
