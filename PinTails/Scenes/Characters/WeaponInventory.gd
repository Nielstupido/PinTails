class_name WeaponInventory
extends Node

const Tail_max_size = 3
enum Weapons {RIFLE, PISTOL}
const Weapons_ref = {Weapons.RIFLE : "Rifle", Weapons.PISTOL : "Pistol"}

@onready var player_interaction = $"../PlayerInteractionComponent"
@onready var weapon_attachment = $"../Neck/Head/WeaponAttachments"
@onready var weapon_drop_point = $"../DropPoint"
@onready var pistol_obj = preload("res://Scenes/Weapon/Pistol/Pistol.tscn")
@onready var rifle_obj = preload("res://Scenes/Weapon/Pistol/Pistol.tscn")

@export_group("Weapon Settings")
## Path to the projectile prefab scene
@export var projectile_prefab : PackedScene
## Speed the projectile spawns with
@export var projectile_velocity : float
## Node the projectile spawns at
@onready var bullet_point = $"../Neck/Head/WeaponAttachments/Pistol/BulletPoint"

## Animation player for weapons
@onready var weapon_animation_player = $"../Neck/Head/WeaponAttachments/WeaponAnimationPlayer"
@onready var weapon_audio_stream_player_3d = $"../Neck/Head/WeaponAttachments/WeaponAudioStreamPlayer3D"

@export var weapon_nodes : Array[Node]

var weapons : Array
var weapon_blend_target = 1
var current_weapon : WeaponData
var current_weapon_node : Node3D


func _ready():
	for node in weapon_nodes:
		node.hide()


func holster():
	if weapons.is_empty() or current_weapon == null:
		return
	
	print("weapon node visible == " + str(current_weapon_node.visible))
	if current_weapon_node.visible:
		player_interaction.is_wielding = false
		weapon_animation_player.play("Pistol_unequip")
	else:
		player_interaction.is_wielding = true
		weapon_animation_player.play("Pistol_equip")


func add_weapon(passed_weapon_data) -> bool:
	if !weapons.has(passed_weapon_data):
		weapons.append(passed_weapon_data)
		change_weapon_to()
		return true
	
	return false


func drop_weapon():
	if weapons.is_empty():
		return
	
	var scene_to_drop = load(current_weapon.drop_scene)
	#Audio.play_sound(slot_data.inventory_item.sound_drop)
	var dropped_item = scene_to_drop.instantiate()
	dropped_item.position = owner.player_interaction_component.get_interaction_raycast_tip(0)
	dropped_item.weapon_data = current_weapon
	GAMEMANAGER.game_node.add_child(dropped_item)
	
	weapons.erase(current_weapon)
	current_weapon_node = null
	
	change_weapon_to()
#		switch_weapon(current_weapon if current_weapon < weapons.size() else  weapons.size() - 1)
		#switch_weapon(current_weapon - 1 if current_weapon > 0 else  weapons.size() - 1)


func equip_weapon(weapon_data : WeaponData):
	current_weapon = weapon_data
	var node_path = "../Neck/Head/WeaponAttachments/" + current_weapon.name
	current_weapon_node = get_node(node_path)
	print("current weapon animation name == " + current_weapon.equip_anim)
	weapon_animation_player.queue(current_weapon.equip_anim)
	player_interaction.is_wielding = true


func change_weapon_to(to = ""):
	if weapons.is_empty():
		return
	
	if current_weapon != null:
		weapon_animation_player.queue(current_weapon.unequip_anim)
		current_weapon.is_being_wielded = false
	current_weapon_node = null
	current_weapon = null
	player_interaction.is_wielding = false
	
	match(to):
		"":
			equip_weapon(weapons[0])
		"Next":
			equip_weapon(weapons[0])
		"Prev":
			equip_weapon(weapons[0])


func attempt_reload():
	if current_weapon == null:
		print("Player weapon is null! or No more ammo left!!")
		return
	
	if current_weapon.current_total_ammo == 0 or (current_weapon.current_total_ammo - current_weapon.current_mag_ammo) == 0:
		print("Not enough ammo stored to reload!")
		return
	
	var ammo_needed : int = abs(current_weapon.mag_size - current_weapon.current_mag_ammo)
	if ammo_needed <= 0:
		print("Magazine is still full.")
		return
	
	if !weapon_animation_player.is_playing(): #Make sure reload isn't interrupting another animation.
		weapon_animation_player.play(current_weapon.reload_anim)
		#Audio.play_sound_3d(equipped_wieldable_node.sound_reload).global_position = equipped_wieldable_node.global_position
	
	current_weapon.on_reload()
	#current_weapon.update_wieldable_data(self)


# Primary function/action of the weapon
func action_primary():
	print("current ammo " + str(current_weapon.current_mag_ammo))
	if current_weapon.current_mag_ammo == 0:
		## play out of ammo audio
		return
	else:
		if !weapon_animation_player.is_playing(): # Enforces fire rate.
			weapon_animation_player.play(current_weapon.use_anim)
			current_weapon.on_shoot()
	
	var Direction = (get_camera_collision() - bullet_point.get_global_transform().origin).normalized()
	
	var Projectile = projectile_prefab.instantiate()
	bullet_point.add_child(Projectile)
	Projectile.damage_amount = current_weapon.weapon_damage
	Projectile.set_linear_velocity(Direction * projectile_velocity)
	#Audio.play_sound_3d(sound_primary_use).global_position = self.global_position
	print("Pistol.gd: action_primary called. Self: ", self)
 

# Secondary function/action of the weapon
func action_secondary(is_released:bool):
	if current_weapon_node == null:
		print("Nothing equipped, but is_wielding was true. This shouldn't happen!")
		return
	
	var camera = get_viewport().get_camera_3d()
	if is_released:
		# ADS Camera Zoom OUT
		var tween_cam = get_tree().create_tween()
		tween_cam.tween_property(camera,"fov", 75, .2)
		var tween_pistol = get_tree().create_tween()
		tween_pistol.tween_property(current_weapon_node, "position", player_interaction.default_position, .2)
	else:
		# ADS Camera Zoom IN
		var tween_cam = get_tree().create_tween()
		tween_cam.tween_property(camera,"fov", player_interaction.ads_fov, .2)
		var tween_pistol = get_tree().create_tween()
		tween_pistol.tween_property(current_weapon_node, "position", Vector3(0,player_interaction.default_position.y,player_interaction.default_position.z), .2)


func get_camera_collision() -> Vector3:
	var viewport = get_viewport().get_size()
	var camera = get_viewport().get_camera_3d()
	
	var Ray_Origin = camera.project_ray_origin(viewport/2)
	var Ray_End = Ray_Origin + camera.project_ray_normal(viewport/2) * current_weapon.weapon_range
	
	var New_Intersection = PhysicsRayQueryParameters3D.create(Ray_Origin,Ray_End)
	var Intersection = player_interaction.get_world_3d().direct_space_state.intersect_ray(New_Intersection)
	
	if not Intersection.is_empty():
		var Col_Point = Intersection.position
		return Col_Point
	else:
		return Ray_End
