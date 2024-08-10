extends Node3D

@export var ammo_type = "Rifle" # (String, "Rifle", "Pistol")

func _ready():
	$SubViewport/Control/Label.text = ammo_type + "\nRefill"
	$MeshInstance3D.material_override = StandardMaterial3D.new()
	$MeshInstance3D.material_override.set_cull_mode(StandardMaterial3D.CULL_DISABLED)
	$MeshInstance3D.material_override.albedo_texture = $SubViewport.get_texture()


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("WeaponStats").ammo_refill(ammo_type)
		pass
