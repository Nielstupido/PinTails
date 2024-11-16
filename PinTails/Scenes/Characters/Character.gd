class_name Character
extends CharacterBody3D

const TAIL_MAX_SIZE = 3
enum Weapons {RIFLE, PISTOL}
const WEAPONS_REF = {Weapons.RIFLE : "Rifle", Weapons.PISTOL : "Pistol"}
@onready var cam = $Camroot
@onready var gun_attachment = $Mesh/Godot_Chan_Stealth_Shooter/Godot_Chan_Stealth/Skeleton3D/gun_attachment
@onready var neck_attachment = $Mesh/Godot_Chan_Stealth_Shooter/Godot_Chan_Stealth/Skeleton3D/neck_attachment
@onready var weapon_fire = {"Rifle" : preload("res://Audio/Rifle_fire.wav"), "Pistol" : preload("res://Audio/Pistol_fire.wav")}
@onready var weapon_reload = {"Rifle" : preload("res://Audio/Rifle_reload.wav"), "Pistol" : preload("res://Audio/Pistol_reload.wav")}
@onready var weapon_ray = $Camroot/h/v/pivot/Camera3D/ray
@onready var weapon_pickup_text = $UI/PickUpWeapon
@onready var tail_pickup_text = $UI/PickUpTail
@onready var buy_weapon_menu = $Shop
@onready var weapon_drop_point = $DropPoint
@onready var tail_manager = $TailManager
@onready var tail_config_menu = $UI/TailConfigMenu
@onready var tail_obj = preload("res://Scenes/Tails/Tail.tscn")
@onready var pistol_obj = preload("res://Scenes/Weapon/Pistol/Pistol.tscn")
@onready var rifle_obj = preload("res://Scenes/Weapon/Rifle/Rifle.tscn")
@onready var bullet_obj = preload("res://Scenes/Weapon/Bullet.tscn")

@onready var weapons = []
@onready var weapons_id = []
var current_weapon = -1
var fired_once = false
var pickupable_weapons : Array
var pickupable_weapons_id : Array

@onready var tails = []
var pickupable_tails : Array
var current_active_tail_attrb : Array

var direction = Vector3.BACK
var strafe_dir = Vector3.ZERO
var strafe = Vector3.ZERO

var aim_turn = 0

var vertical_velocity = 0
var gravity = 28
var weight_on_ground = 5

var health = 100
var movement_speed = 0
var walk_speed = 2.2
var crouch_walk_speed = 1
var run_speed = 5
var acceleration = 6
var angular_acceleration = 7
var footstep_volume = 10
var current_weapon_dmg = 0

#<--- player tail stats --->
var adtnl_movement_speed = 0
var adtnl_armor = 0
var adtnl_max_health = 0
var adtnl_footstep_silencer = 0
var adtnl_melee_dmg = 0
#<--- player tail stats --->

var jump_magnitude = 15
var roll_magnitude = 20

var sprinting = false
var ag_transition = "parameters/ag_transition/current"
var ag_weapon_transition = "parameters/ag_weapon_transition/current"
var aim_transition = "parameters/aim_transition/current"
var crouch_iw_blend = "parameters/crouch_iw_blend/blend_amount"
var crouch_walk_blendspace = "parameters/crouch_walk/blend_position"
var cs_transition = "parameters/cs_transition/current"
var ir_rifle_blend = "parameters/ir_rifle_blend/blend_amount"
var iwr_blend = "parameters/iwr_blend/blend_amount"
var jump_blend = "parameters/jump_blend/blend_position"
var reload_active = "parameters/reload/active"
var roll_active = "parameters/roll/active"
var roll_blend = "parameters/roll_blend/blend_position"
var walk_blendspace = "parameters/walk/blend_position"
var weapon_blend = "parameters/weapon_blend/blend_amount"
var weapon_switch_active = "parameters/weapon_switch/active"

var cam_holster = "parameters/holster/blend_amount"
var cam_shoulder = "parameters/shoulder_weapon/blend_position"
var cam_crouch_stand = "parameters/crouch_stand/blend_position"
var cam_aim = "parameters/aim/blend_position"

var weapon_blend_target = 1
var crouch_stand_target = 1
var shoulder_target = 0.5

var aim_speed = 10
var radial_menu = false
var splatter = 0
var weapon_ray_tip = Vector3()

var buy_menu = false

var player_id = 0


func _ready():
	tail_config_menu.hide()
	randomize()
	direction = Vector3.BACK.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y)
	$AnimationTree.set("parameters/walk_scale/scale", walk_speed)
	switch_weapon(0)
	$splatters.set_as_top_level(true)
	holster()
	add_tail(MATCHMANAGER.match_players.get(MATCHMANAGER.player_name), GAMEMANAGER.get_tail_id())
	GAMEMANAGER.emit_signal("tail_picked_up", tails[tails.size() - 1])
	setup_keybinds_UI()


func _input(event):
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.015 # animates player strafe, when standing, aiming, and looking left right
	
	if event is InputEventKey:
		if event.as_text() == "W" || event.as_text() == "A" || event.as_text() == "S" || event.as_text() == "D" || event.as_text() == "Space" || event.as_text() == "Control" || event.as_text() == "Shift" || event.as_text() == "X" || event.as_text() == "F" || event.as_text() == "Q" || event.as_text() == "C" || event.as_text() == "Z" || event.as_text() == "R":
			if event.pressed:
				get_node("Status/" + event.as_text()).color = Color("ff6666")
			else:
				get_node("Status/" + event.as_text()).color = Color("ffffff")
	
	sprinting = Input.is_action_pressed("sprint")
	
	if Input.is_key_pressed(KEY_1):
		switch_weapon(0)
	if Input.is_key_pressed(KEY_2):
		switch_weapon(1)
	
	if event.is_action_pressed("holster"):
		holster()
	
	if weapon_blend_target && !buy_menu:
		if event.is_action_pressed("shoulder_change"):
			shoulder_target *= -1.0
		
#		if $AnimationTree.get(aim_transition) == 0:
#			if event.is_action_pressed("lean_right"):
#				shoulder_target = 0.5 if shoulder_target == 1.0 else 1.0
#			
#			if event.is_action_pressed("lean_left"):
#				shoulder_target = -0.5 if shoulder_target == -1.0 else -1.0
		
		if event.is_action_pressed("reload"):
			reload()
	
	if event.is_action_released("fire"):
		fired_once = false
	
	if event.is_action_pressed("pick_up"):
		if !pickupable_weapons.is_empty():
			if add_weapon(pickupable_weapons[0], pickupable_weapons_id[0]):
				GAMEMANAGER.emit_signal("weapon_picked_up", weapons_id[weapons_id.size() - 1])
	
	if event.is_action_pressed("drop_weapon"):
		drop_weapon()
	
	if event.is_action_pressed("next_weapon"):
		switch_weapon(current_weapon + 1 if current_weapon < weapons.size() - 1 else 0)
	
	if event.is_action_pressed("prev_weapon"):
		switch_weapon(current_weapon - 1 if current_weapon > 0 else  weapons.size() - 1)
	
	if event.is_action_pressed("buy_menu"):
		buy_weapon_menu.open_buy_menu()


func _physics_process(delta):
	if pickupable_weapons.is_empty():
		weapon_pickup_text.hide()
	else:
		weapon_pickup_text.show()
	
	if pickupable_tails.is_empty():
		tail_pickup_text.hide()
	else:
		tail_pickup_text.show()
	
	if !$roll_timer.is_stopped(): # we only need roll_timer to change acceleration in the middle (using wait_time)
		acceleration = 3.5
	else:
		acceleration = 5
	
	if Input.is_action_pressed("crouch"):
		if $crouch_timer.is_stopped() && !$AnimationTree.get(roll_active):
			crouch_stand_target = 0
			$crouch_timer.start()
			$AnimationTree.tree_root.get_node("cs_transition").xfade_time = (velocity.length() + 1.5)/ 15.0
			$AnimationTree.set(cs_transition, crouch_stand_target)
	else:
		if $crouch_timer.is_stopped() && !$AnimationTree.get(roll_active) && $AnimationTree.get(cs_transition) != 1:
			crouch_stand_target = 1
			$crouch_timer.start()
			$AnimationTree.tree_root.get_node("cs_transition").xfade_time = (velocity.length() + 1.5)/ 15.0
			$AnimationTree.set(cs_transition, crouch_stand_target)
	
	if Input.is_action_pressed("aim") and weapons.size() != 0:
		$Status/Aim.color = Color("ff6666")
	else:
		$Status/Aim.color = Color("ffffff")
	
	var h_rot = $Camroot/h.global_transform.basis.get_euler().y
	
	if Input.is_action_just_pressed("attach_tail"):
		if !pickupable_tails.is_empty():
			if add_tail(pickupable_tails[0]):
				GAMEMANAGER.emit_signal("tail_picked_up", tails[tails.size() - 1])
	elif Input.is_action_pressed("attach_tail"):
		if !tail_config_menu.visible:
			cam.set_process_input(false)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			tail_config_menu.show()
	elif tail_config_menu.visible:
		cam.set_process_input(true)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		tail_config_menu.hide()
	
	if Input.is_action_pressed("forward") ||  Input.is_action_pressed("backward") ||  Input.is_action_pressed("left") ||  Input.is_action_pressed("right"):
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"),
					0,
					Input.get_action_strength("forward") - Input.get_action_strength("backward"))
		
		strafe_dir = direction
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
		
		if sprinting && $AnimationTree.get(aim_transition) == 1 && crouch_stand_target:
			movement_speed = run_speed
		else:
			if crouch_stand_target:
				movement_speed = walk_speed
			else:
				movement_speed = crouch_walk_speed
	
	else:
		movement_speed = 0
		strafe_dir = Vector3.ZERO
		
		if $AnimationTree.get(aim_transition) == 0:
			direction = $Camroot/h.global_transform.basis.z
	
	velocity = lerp(velocity, direction * (movement_speed + adtnl_max_health), delta * acceleration)
	
	set_velocity(velocity + Vector3.UP * vertical_velocity - get_floor_normal() * weight_on_ground)
	set_up_direction(Vector3.UP)
	move_and_slide()
	
	if !is_on_floor():
		vertical_velocity -= gravity * delta
	else:
		if vertical_velocity < -20:
			roll()
		vertical_velocity = 0
	
# ======================================= AIM MODE START ==============================
	if (Input.is_action_pressed("aim")) && !$AnimationTree.get(roll_active) && weapon_blend_target == 1:
		$CamAnimTree.set(cam_aim, lerp($CamAnimTree.get(cam_aim), 1, delta * aim_speed))
	else:
		$CamAnimTree.set(cam_aim, lerp($CamAnimTree.get(cam_aim), 0, delta * aim_speed))
	
	if (Input.is_action_pressed("aim") || Input.is_action_pressed("fire") || !$aim_stay_delay.is_stopped()) && !$AnimationTree.get(roll_active) && weapon_blend_target == 1:
		
		if Input.is_action_pressed("fire") and weapons.size() != 0:
			$aim_stay_delay.start()
			
			if $shoot_timer.is_stopped() && $reload_timer.is_stopped() && !$AnimationTree.get(weapon_switch_active) && $WeaponStats.mag() > 0 && ($WeaponStats.auto() || !fired_once):# weapon stats 
			
				fired_once = true
			
				$shoot_timer.start(1 / $WeaponStats.fire_rate())
				$shoot_sfx.play()
				
				$WeaponStats.mag_decrement()
				
				$UI/Crosshair.fire($WeaponStats.fire_rate() * 0.2)
				
				neck_attachment.get_node("AnimationPlayer").play("muzzle_flash")
				
				$splatters.get_child(splatter).global_transform.origin = weapon_ray_tip
				$splatters.get_child(splatter).emitting = true
				
				splatter += 1
				if splatter >= $splatters.get_child_count() - 1:
					splatter = 0
				
				var spread = $UI/Crosshair.pos_x/12
				weapon_ray.rotation_degrees.x = randf_range(-spread, spread)
				weapon_ray.rotation_degrees.y = randf_range(-spread, spread)
				
				#firing bullet
				var bullet_instance = bullet_obj.instance()
				GAMEMANAGER.game_node.add_child(bullet_instance)
				bullet_instance.setup_bullet(weapon_ray.global_transform, current_weapon_dmg)
				
				$Camroot/h/v.rotate_x(deg_to_rad($WeaponStats.recoil()))
				$Camroot.recoil_recovery()
		
		
		if $AnimationTree.get(aim_transition) == 1:
			$AnimationTree.set(aim_transition, 0)
			$Mesh/Godot_Chan_Stealth_Shooter/Godot_Chan_Stealth/Skeleton3D/spine_ik.start()
			$AnimationTree.set("parameters/neck_front/blend_amount", 1)
		
		if $AnimationTree.get(roll_active):
			$Mesh.rotation.y = lerp_angle  ($Mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta * angular_acceleration)
			# Sometimes in the level design you might need to rotate the Player object itself
			# - rotation.y in case you need to rotate the Player object
		else:
			$Mesh.rotation.y = $Camroot/h.rotation.y # when not rolling, Mesh will face where camera is facing. Not lerping as weapon will lerp too.
		
		strafe = lerp(strafe, strafe_dir + Vector3.RIGHT * aim_turn, delta * acceleration)
		
		if !$AnimationTree.get(roll_active):
			$AnimationTree.set(walk_blendspace, Vector2(-strafe.x, strafe.z))
			$AnimationTree.set(crouch_walk_blendspace, Vector2(-strafe.x, strafe.z))
		
		$AnimationTree.set(iwr_blend, lerp($AnimationTree.get(iwr_blend), 0, delta * acceleration))
		$AnimationTree.set(crouch_iw_blend, lerp($AnimationTree.get(crouch_iw_blend), 1, delta * acceleration))
	
	else:
		shoulder_target = 0.5 * sign(shoulder_target)
		
		if $AnimationTree.get(aim_transition) == 0:
			$AnimationTree.set(aim_transition, 1)
			$Mesh/Godot_Chan_Stealth_Shooter/Godot_Chan_Stealth/Skeleton3D/spine_ik.stop()
			$Mesh/Godot_Chan_Stealth_Shooter/Godot_Chan_Stealth/Skeleton3D.clear_bones_global_pose_override()
			$AnimationTree.set("parameters/neck_front/blend_amount", 0)
		
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta * angular_acceleration)
		
		if !$AnimationTree.get(roll_active): # so that roll anim fades out to last walk anim blend position
			$AnimationTree.set(walk_blendspace, lerp($AnimationTree.get(walk_blendspace), Vector2(0,1), delta * acceleration))
			$AnimationTree.set(crouch_walk_blendspace, lerp($AnimationTree.get(crouch_walk_blendspace), Vector2(0,1), delta * acceleration))
	
		var iw_blend = (velocity.length() - walk_speed) / walk_speed
		var wr_blend = (velocity.length() - walk_speed) / (run_speed - walk_speed)
	
	
		if velocity.length() <= walk_speed:
			$AnimationTree.set(iwr_blend , iw_blend)
			$AnimationTree.set(ir_rifle_blend, 0)
		else:
			$AnimationTree.set(iwr_blend , wr_blend)
			$AnimationTree.set(ir_rifle_blend, wr_blend)
	
		$AnimationTree.set(crouch_iw_blend, velocity.length()/crouch_walk_speed)
	# ======================================= AIM MODE END ===================================
	
	
	# ======================================= JUMP/ ROLL START ===============================
	if is_on_floor():
		$AnimationTree.set(ag_transition, 1)
		$AnimationTree.set(ag_weapon_transition, crouch_stand_target)
		
		if !$AnimationTree.get(roll_active):
			if Input.is_action_just_pressed("jump"):
				crouch_stand_target = 1
				$AnimationTree.set(cs_transition, 1)
				
				vertical_velocity = jump_magnitude
		
			if Input.is_action_just_pressed("roll"):
				roll()
				
	else:
		$AnimationTree.set(ag_transition, 0)
		$AnimationTree.set(ag_weapon_transition, 0)
		
		$AnimationTree.set(jump_blend, lerp($AnimationTree.get(jump_blend), vertical_velocity/jump_magnitude, delta * 10))
		
	# ======================================= JUMP/ ROLL END ================================
	
	$AnimationTree.set(weapon_blend, lerp($AnimationTree.get(weapon_blend), weapon_blend_target, delta * 10))
	$AnimationTree.set(roll_blend, lerp($AnimationTree.get(roll_blend), weapon_blend_target, delta * 5))
	$CamAnimTree.set(cam_holster, lerp($CamAnimTree.get(cam_holster), weapon_blend_target, delta * 5))
	$CamAnimTree.set(cam_shoulder, lerp($CamAnimTree.get(cam_shoulder), shoulder_target, delta * 7))
	$CamAnimTree.set(cam_crouch_stand, lerp($CamAnimTree.get(cam_crouch_stand), crouch_stand_target, delta * 4))
	
	if weapons.size() != 0:
		if $WeaponStats.mag() < 1 && $reload_timer.is_stopped() && !$AnimationTree.get(roll_active):
			reload()
	
		aim_turn = 0
		
		$UI/Crosshair.pos_x = $WeaponStats.spread() + $WeaponStats.movement_spread() * velocity.length() + $WeaponStats.jump_spread() * int(!is_on_floor())
		$UI/Crosshair.pos_x += $WeaponStats.aim_spread() * $CamAnimTree.get(cam_aim) + $WeaponStats.crouch_spread() * (1 - crouch_stand_target)
		
		$UI/Mag/mag.text = String($WeaponStats.mag())
		$UI/Mag/ammo_backup.text = String($WeaponStats.ammo_backup())
		
	if weapon_ray.is_colliding() && (weapon_ray.get_collision_point()-weapon_ray.global_transform.origin).length() > 0.1:
		weapon_ray_tip = weapon_ray.get_collision_point()
	else:
		weapon_ray_tip = (weapon_ray.get_target_position().z * weapon_ray.global_transform.basis.z) + weapon_ray.global_transform.origin
	
	neck_attachment.get_node("streaks").look_at(weapon_ray_tip, Vector3.UP)


func setup_keybinds_UI():
	weapon_pickup_text.text = "Press " + str(OS.get_keycode_string((InputMap.action_get_events("pick_up"))[0].keycode)) + " to pick up weapon"
	tail_pickup_text.text = "Press " + str(OS.get_keycode_string((InputMap.action_get_events("attach_tail"))[0].keycode)) + " to attach tail"


func holster():
	if weapons.is_empty():
		weapon_blend_target = 0
		gun_attachment.set("visible", false)
		return
	
	weapon_blend_target = 1 - weapon_blend_target
	gun_attachment.set("visible", !gun_attachment.get("visible"))
	
	if weapons.size() == 1:
		current_weapon = 0
		switch_weapon(current_weapon) 


func add_weapon(passed_weapon, passed_weapon_id) -> bool:
	if !weapons.has(passed_weapon):
		weapons.append(passed_weapon)
		weapons_id.append(passed_weapon_id)
		if weapons.size() == 1:
			holster()
		return true
	
	return false


func drop_weapon():
	if weapons.is_empty():
		return
	
	var weapon_instance : Weapon_old
	match(weapons[current_weapon]):
		Weapons.PISTOL:
			weapon_instance = pistol_obj.instance()
		Weapons.RIFLE:
			weapon_instance = rifle_obj.instance()
	
	GAMEMANAGER.game_node.add_child(weapon_instance)
	weapon_instance.global_transform = weapon_drop_point.global_transform;
	weapon_instance.id = weapons_id[current_weapon]
	
	weapons.pop_at(current_weapon)
	weapons_id.pop_at(current_weapon)
	
	if weapons.is_empty():
		holster()
	else:
#		switch_weapon(current_weapon if current_weapon < weapons.size() else  weapons.size() - 1)
		switch_weapon(current_weapon - 1 if current_weapon > 0 else  weapons.size() - 1)


func add_tail(passed_tail, passed_tail_id = -1) -> bool:
	if !tails.has(passed_tail):
		if passed_tail_id != -1:
			passed_tail.id = passed_tail_id
		tails.append(passed_tail)
		print("passed tail == " + str(passed_tail))
		return true
	
	return false


func erase_tail(passed_tail):
	var tail_instance = tail_obj.instance()
	tail_instance.global_transform = weapon_drop_point.global_transform;
	tail_instance.prepare_tail(passed_tail)
	GAMEMANAGER.get_node(".").add_child(tail_instance)
	
	tails.erase(tails.find(passed_tail))
	tail_manager.erase_tail_attr(passed_tail)


func roll():
	$AnimationTree.set(roll_active, true)
	$roll_timer.start()
	velocity = (direction - get_floor_normal()) * roll_magnitude
	$AnimationTree.set(reload_active, false) #cancelling reload if rolling
	$reload_timer.stop() #cancelling reload if rolling
	$AnimationTree.set(crouch_walk_blendspace, Vector2(0, 0))
	# so that roll anim fades out to crouch idle anim
	# need this only for crouch as blending roll to crouch_walk gives weirdness (for the difference of root bone position)


func switch_weapon(to):
	if !weapons.is_empty():
		if to < weapons.size() && (to != current_weapon || weapon_blend_target == 0 || weapons.size() == 1):
			weapon_blend_target = 1
			gun_attachment.show()
			
			current_weapon = to
			$AnimationTree.set("parameters/weapon_change_aim/blend_position", weapons[current_weapon])
			$AnimationTree.set("parameters/weapon_change_on_air/blend_position", weapons[current_weapon])
			$AnimationTree.set("parameters/weapon_change_run/blend_position", weapons[current_weapon])
			$AnimationTree.set("parameters/weapon_change_switch/blend_position", weapons[current_weapon])
			$AnimationTree.set("parameters/weapon_change_idle/blend_position", weapons[current_weapon])
			
			for gun_node in gun_attachment.get_children():
				gun_node.hide()
			
			gun_attachment.get_node($WeaponStats.weapon_name()).show()
			current_weapon_dmg = $WeaponStats.damage()
			
			$AnimationTree.set("parameters/weapon_switch_scale/scale", $WeaponStats.switch_speed())
			$AnimationTree.set("parameters/weapon_switch_seek/seek_position", 0)
			$AnimationTree.set(weapon_switch_active, true)
			$reload_timer.stop()#cancelling reload if weapon switching
			$AnimationTree.set(reload_active, false)#cancelling reload if weapon switching
			
			neck_attachment.get_node("muzzle_flash").speed_scale = $WeaponStats.fire_rate()
			neck_attachment.get_node("streaks").speed_scale = $WeaponStats.fire_rate() / 1.45
			neck_attachment.get_node("streaks").process_material.gravity.z = -(8000 / $WeaponStats.fire_rate())
			neck_attachment.get_node("AnimationPlayer").playback_speed = clamp($WeaponStats.fire_rate(), 5, 10)
			$shoot_sfx.stream.audio_stream = weapon_fire[$WeaponStats.weapon_name()]


func reload():
	if weapons.is_empty():
		return
	
	if $WeaponStats.mag() != $WeaponStats.mag_size() && $WeaponStats.ammo_backup() != 0:
		$AnimationTree.set("parameters/reload_scale/scale", $WeaponStats.reload_speed())
		$AnimationTree.set(reload_active, true)
		$reload_timer.start(1 / $WeaponStats.reload_speed())
		$reload_sfx.stream = weapon_reload[$WeaponStats.weapon_name()]
		$reload_sfx.play()


func _on_reload_timer_timeout():
	$WeaponStats.mag_fill()


func on_player_hit(damage_amount):
	self.health -= damage_amount
	print("player hit = " + str(self.health))
	if self.health <= 0:
		print("Player Dead!")


func _on_WeaponPickupRange_area_entered(area):
	if "Rifle" in area.owner.name:
		if pickupable_weapons.has(Weapons.RIFLE):
			pickupable_weapons.erase(pickupable_weapons.find(Weapons.RIFLE))
			pickupable_weapons_id.erase(pickupable_weapons.find(Weapons.RIFLE))
		pickupable_weapons.push_front(Weapons.RIFLE)
		pickupable_weapons_id.push_front(area.owner.id)
	
	if "Pistol" in area.owner.name:
		pickupable_weapons.append(Weapons.PISTOL)
		if pickupable_weapons.has(Weapons.PISTOL):
			pickupable_weapons.erase(pickupable_weapons.find(Weapons.PISTOL))
		pickupable_weapons.push_front(Weapons.PISTOL)
		pickupable_weapons_id.push_front(area.owner.id)


func _on_WeaponPickupRange_area_exited(area):
	if "Rifle" in area.owner.name and pickupable_weapons.has(Weapons.RIFLE): 
		pickupable_weapons_id.erase(pickupable_weapons.find(Weapons.RIFLE))
		pickupable_weapons.erase(pickupable_weapons.find(Weapons.RIFLE))
	
	if "Pistol" in area.owner.name and pickupable_weapons.has(Weapons.PISTOL):
		pickupable_weapons_id.erase(pickupable_weapons.find(Weapons.PISTOL))
		pickupable_weapons.erase(pickupable_weapons.find(Weapons.PISTOL))


func _on_TailPickupRange_area_entered(area):
	print("tails size == " + str(tails.size()))
	if area.owner.is_in_group("Tail") and tails.size() != TAIL_MAX_SIZE:
		if pickupable_tails.has(area.owner.tail_data):
			pickupable_tails.erase(pickupable_tails.find(area.owner.tail_data))
		pickupable_tails.push_front(area.owner.tail_data)


func _on_TailPickupRange_area_exited(area):
	if area.owner.is_in_group("Tail") and pickupable_tails.has(area.owner.tail_data):
		pickupable_tails.erase(pickupable_tails.find(area.owner.tail_data))
