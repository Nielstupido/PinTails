class_name WeaponInventory
extends Node

const TAIL_MAX_SIZE = 3

@onready var pistol_obj = preload("res://Scenes/Weapon/Pistol/Pistol.tscn")
@onready var rifle_obj = preload("res://Scenes/Weapon/Pistol/Pistol.tscn")

@export_group("Weapon Settings")
## Speed the projectile spawns with
@export var projectile_velocity : float
## Node the projectile spawns at
@onready var projectile_point = $"../Neck/Head/WeaponAttachments/Pistol/BulletPoint"
var weapon_projectile_path = "res://Scenes/Weapon/WeaponProjectile.tscn"

## Animation player for weapons
@onready var weapon_animation_player = $"../Neck/Head/WeaponAttachments/WeaponAnimationPlayer"
@onready var weapon_audio_stream_player_3d = $"../Neck/Head/WeaponAttachments/WeaponAudioStreamPlayer3D"

@export var weapon_nodes : Array[Node]

var weapons : Array
var weapon_blend_target = 1
var current_weapon_data : WeaponData
var current_weapon_node : Node3D


func _ready():
	for node in weapon_nodes:
		node.hide()


func holster() -> void:
	if weapons.is_empty() or current_weapon_data == null:
		return
	
	if current_weapon_node.visible:
		owner.player_interaction_component.is_wielding = false
		weapon_animation_player.play(current_weapon_data.unequip_anim)
	else:
		owner.player_interaction_component.is_wielding = true
		weapon_animation_player.play(current_weapon_data.equip_anim)


func add_weapon(passed_weapon_data : WeaponData) -> bool:
	if weapons.has(passed_weapon_data):
		return false
	
	if !passed_weapon_data.was_picked_up:
		passed_weapon_data.picked_up()
	
	weapons.append(passed_weapon_data)
	
	if weapons.size() > 1:
		switch_weapon("Next")
	else:
		switch_weapon()
	return true


func drop_weapon() -> void:
	if weapons.is_empty():
		return
	
	var scene_to_drop = load(current_weapon_data.drop_scene_path)
	#Audio.play_sound(slot_data.inventory_item.sound_drop)
	#dropped_item.weapon_data = current_weapon_data
	
	rpc("_rpc_drop", owner.name)
	get_tree().root.get_node("Game/Map/MapTest").spawner.rpc("spawn_weapon",
			owner.player_interaction_component.get_interaction_raycast_tip(0),
			current_weapon_data.weapon_type,
			current_weapon_data.stringify())
	
	var item_index = weapons.bsearch(current_weapon_data)
	weapons.remove_at(item_index)
	
	if weapons.is_empty():
		current_weapon_node = null
		current_weapon_data = null
		owner.player_interaction_component.is_wielding = false
	else:
		if weapons.front() != current_weapon_data:
			equip_weapon(weapons[item_index - 1])


@rpc("any_peer", "call_local", "reliable")
func _rpc_drop(player_id : String) -> void:
	if player_id == owner.name:
		weapon_animation_player.play(current_weapon_data.unequip_anim)


func equip_weapon(weapon_data : WeaponData) -> void:
	var data_str_bytes = weapon_data.stringify()
	rpc("_rpc_equip", owner.name, data_str_bytes)


@rpc("any_peer", "call_local", "reliable")
func _rpc_equip(player_id : String, data_str_bytes : String) -> void:
	if player_id == owner.name:
		var json = JSON.new()
		var err = json.parse(data_str_bytes)
		#print(str(owner.name) + " = weapon name == " + str(data_str_bytes))
		
		if err == OK:
			current_weapon_data = WeaponData.new()
			current_weapon_data.set_string_to_data(json.data)
		else:
			print("<<<<< TAIL DATA PARSE ERR >>>>>")
			return
		
		#print(str(owner.name) + " = weapon data == " + str(current_weapon_data.stringify()))
		var node_path = "../Neck/Head/WeaponAttachments/" + current_weapon_data.weapon_name
		current_weapon_node = get_node(node_path)
		weapon_animation_player.queue(current_weapon_data.equip_anim)
		owner.player_interaction_component.is_wielding = true


func switch_weapon(to : String = "") -> void:
	## weapon switching only allowed if player has more than 1 weapon
	if ((weapons.size() == 1 && current_weapon_data != null) || weapons.is_empty()):
		return
	
	## weapon switching only allowed if weapon is not holstered
	if (!owner.player_interaction_component.is_wielding && weapons.size() > 1):
		return
	
	if current_weapon_data != null and owner.player_interaction_component.is_wielding:
		weapon_animation_player.play(current_weapon_data.unequip_anim)
	
	match(to):
		"":
			equip_weapon(weapons.front())
		"Next":
			if weapons.back() != current_weapon_data:
				equip_weapon(weapons[weapons.rfind(current_weapon_data) + 1])
			else:
				equip_weapon(weapons.front())
		"Prev":
			if weapons.front() != current_weapon_data:
				equip_weapon(weapons[weapons.rfind(current_weapon_data) - 1])
			else:
				equip_weapon(weapons.back())


func attempt_reload() -> void:
	if current_weapon_data == null:
		print("Player weapon is null! or No more ammo left!!")
		return
	
	if current_weapon_data.current_total_ammo == 0 or (current_weapon_data.current_total_ammo - current_weapon_data.current_mag_ammo) == 0:
		print("Not enough ammo stored to reload!")
		return
	
	var ammo_needed : int = abs(current_weapon_data.mag_size - current_weapon_data.current_mag_ammo)
	if ammo_needed <= 0:
		print("Magazine is still full.")
		return
	
	if !weapon_animation_player.is_playing(): #Make sure reload isn't interrupting another animation.
		weapon_animation_player.play(current_weapon_data.reload_anim)
		#Audio.play_sound_3d(equipped_wieldable_node.sound_reload).global_position = equipped_wieldable_node.global_position
	
	current_weapon_data.on_reload()
	#current_weapon_data.update_wieldable_data(self)


## Primary function/action of the weapon
func action_primary() -> void:
	print("current ammo " + str(current_weapon_data.current_mag_ammo))
	if current_weapon_data.current_mag_ammo == 0:
		## play out of ammo audio
		return
	else:
		if !weapon_animation_player.is_playing(): # Enforces fire rate.
			weapon_animation_player.play(current_weapon_data.use_anim)
			current_weapon_data.on_shoot()
	
	var var_dict = {
		"camera_collision" : get_camera_collision(),
		"damage_amount" : current_weapon_data.weapon_damage}
	
	get_tree().root.get_node("Game/Map/MapTest").spawner.rpc(
		"spawn_object", 
		projectile_point.get_path(),
		weapon_projectile_path,
		var_dict)
	
	#Audio.play_sound_3d(sound_primary_use).global_position = self.global_position
	print("Pistol.gd: action_primary called. Self: ", self)
 

# Secondary function/action of the weapon
func action_secondary(is_released : bool) -> void:
	if current_weapon_node == null:
		print("Nothing equipped, but is_wielding was true. This shouldn't happen!")
		return
	
	var camera = get_viewport().get_camera_3d()
	if is_released:
		# ADS Camera Zoom OUT
		var tween_cam = get_tree().create_tween()
		tween_cam.tween_property(camera,"fov", 75, .2)
		var tween_pistol = get_tree().create_tween()
		tween_pistol.tween_property(current_weapon_node, "position", owner.player_interaction_component.default_position, .2)
	else:
		# ADS Camera Zoom IN
		var tween_cam = get_tree().create_tween()
		tween_cam.tween_property(camera,"fov", owner.player_interaction_component.ads_fov, .2)
		var tween_pistol = get_tree().create_tween()
		tween_pistol.tween_property(current_weapon_node, "position", Vector3(0,owner.player_interaction_component.default_position.y,owner.player_interaction_component .default_position.z), .2)


func get_camera_collision() -> Vector3:
	var viewport = get_viewport().get_size()
	var camera = get_viewport().get_camera_3d()
	
	var Ray_Origin = camera.project_ray_origin(viewport/2)
	var Ray_End = Ray_Origin + camera.project_ray_normal(viewport/2) * current_weapon_data.weapon_range
	
	var New_Intersection = PhysicsRayQueryParameters3D.create(Ray_Origin,Ray_End)
	var Intersection = owner.player_interaction_component.get_world_3d().direct_space_state.intersect_ray(New_Intersection)
	
	if not Intersection.is_empty():
		var Col_Point = Intersection.position
		return Col_Point
	else:
		return Ray_End
