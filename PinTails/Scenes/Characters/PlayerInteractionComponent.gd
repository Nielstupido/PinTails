extends Node3D
class_name PlayerInteractionComponent

const TAIL_MAX_SIZE = 3
const HOLD_TIME_THRES = 5
signal interaction_prompt(interaction_text : String)
signal hint_prompt(hint_icon:Texture2D, hint_text: String)
signal set_use_prompt(use_text:String)
signal updated_wieldable_data(wieldable_icon:Texture2D, wieldable_text: String)

## Raycast3D for interaction check.
@export var carryable_position : Node3D

@onready var buy_weapon_menu = $"../UI/Shop"

## The Field Of View change when aiming down sight. In degrees.
@export var ads_fov = 65
@export var default_position : Vector3

@export_group("Audio")
@export var sound_primary_use : AudioStream
@export var sound_secondary_use : AudioStream
@export var sound_reload : AudioStream

var is_wielding : bool
var throw_power : float = 1.5
var look_vector : Vector3
var is_reset : bool  = true
var device_id : int = -1
var obj_in_focus = null
var pickupable_tail_obj : Object = null
var hold_time : float = 0.0


func _process(delta):
	if Input.is_action_pressed("attach_tail") and owner.is_multiplayer_authority():
		hold_time += (delta * 15)
		if hold_time > HOLD_TIME_THRES:
			if !owner.tail_config_menu.visible:
				owner.is_looking_aroung_paused = true
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				owner.tail_config_menu.show()
	elif Input.is_action_just_released("attach_tail") and owner.is_multiplayer_authority():
		if hold_time < HOLD_TIME_THRES:
			if pickupable_tail_obj != null:
				if owner.tail_manager.add_tail(pickupable_tail_obj.tail_data):
					pickupable_tail_obj.pick_up()
					GAMEPLAYMANAGER.emit_signal("tail_picked_up", pickupable_tail_obj.tail_data)
					
					if owner.tail_manager.tails.size() == TAIL_MAX_SIZE:
						emit_signal("interaction_prompt", "")
						pickupable_tail_obj = null
		hold_time = 0
	elif owner.tail_config_menu.visible:
		owner.is_looking_aroung_paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		owner.tail_config_menu.hide()
	
	if owner.interaction_raycast.is_colliding():
		var interactable = owner.interaction_raycast.get_collider()
		if obj_in_focus != interactable and interactable.has_method("pick_up"):
			obj_in_focus = interactable
			is_reset = false
			emit_signal("interaction_prompt", interactable.interaction_text)
	else:
		if !is_reset:
			obj_in_focus = null
			is_reset = true
			emit_signal("interaction_prompt", "")
		
	# VECTOR 3 for where the player is currently looking
	var dir = (carryable_position.get_global_transform().origin - get_global_transform().origin).normalized()
	look_vector = dir


func _input(event):
	if !owner.is_looking_aroung_paused and owner.is_multiplayer_authority():
		if event.is_action_pressed("buy_menu"):
			buy_weapon_menu.open_buy_menu() 
		
		if event.is_action_pressed("drop_weapon"):
			owner.weapon_inventory.drop_weapon()
		
		if event.is_action_pressed("pick_up"):
			if obj_in_focus != null and obj_in_focus.has_method("pick_up"):
				if owner.weapon_inventory.add_weapon(obj_in_focus.weapon_data):
					obj_in_focus.pick_up()
		
		# Wieldable primary Action Input
		if !get_parent().is_movement_paused:
			if Input.is_action_just_pressed("action_primary"):
				if owner.skill_manager.is_waiting_shot_trigger:
					owner.skill_manager.execute_skill()
				elif is_wielding and !owner.skill_manager.is_timed_trigger_enabled:
					owner.weapon_inventory.action_primary()
			
			if !owner.skill_manager.is_timed_trigger_enabled:
				if is_wielding and Input.is_action_just_pressed("action_secondary"):
					owner.weapon_inventory.action_secondary(false)
				if is_wielding and Input.is_action_just_released("action_secondary"):
					owner.weapon_inventory.action_secondary(true)
			
			if is_wielding and event.is_action_pressed("reload"):
				if owner.interaction_raycast.is_colliding() and owner.interaction_raycast.get_collider().has_method("interact"):
					return
				else:
					owner.weapon_inventory.attempt_reload()
		
		# Weapon switching using middle mouse dial
		if event.is_action_pressed("next_weapon"):
			owner.weapon_inventory.switch_weapon("Next")
		
		if event.is_action_pressed("prev_weapon"):
			owner.weapon_inventory.switch_weapon("Prev")
		
		if event.is_action_pressed("holster"):
			owner.weapon_inventory.holster() 


## Helper function to always get raycast destination point
func get_interaction_raycast_tip(distance_offset : float) -> Vector3:
	if owner.interaction_raycast.is_colliding():
		return owner.interaction_raycast.get_collision_point() 
	else:
		var destination_point = owner.interaction_raycast.global_position + (owner.interaction_raycast.target_position.z - distance_offset) * get_viewport().get_camera_3d().get_global_transform().basis.z
		return destination_point


func _on_tail_collision_area_body_entered(body):
	if !owner.is_multiplayer_authority():
		return
	
	if body.is_in_group("Tail") and owner.tail_manager.tails.size() != TAIL_MAX_SIZE:
		print("Tail data == " + str(body) + " data == " + str(body.tail_data))
		emit_signal("interaction_prompt", body.interaction_text)
		pickupable_tail_obj = body


func _on_tail_collision_area_body_exited(body):
	if !owner.is_multiplayer_authority():
		return
	
	if body.is_in_group("Tail")and owner.tail_manager.tails.size() != TAIL_MAX_SIZE and pickupable_tail_obj != null:
		if body.tail_data == pickupable_tail_obj.tail_data:
			emit_signal("interaction_prompt", "")
			pickupable_tail_obj = null
