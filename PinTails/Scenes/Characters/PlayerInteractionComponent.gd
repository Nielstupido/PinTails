extends Node3D
class_name PlayerInteractionComponent

signal interaction_prompt(interaction_text : String)
signal hint_prompt(hint_icon:Texture2D, hint_text: String)
signal set_use_prompt(use_text:String)
signal updated_wieldable_data(wieldable_icon:Texture2D, wieldable_text: String)

## Raycast3D for interaction check.
@export var interaction_raycast : RayCast3D
@export var carryable_position : Node3D

@onready var weapon_inventory = $"../WeaponInventory"

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


func _process(_delta):
	if interaction_raycast.is_colliding():
		var interactable = interaction_raycast.get_collider()
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
	if event.is_action_pressed("drop_weapon"):
		weapon_inventory.drop_weapon()
	
	if event.is_action_pressed("pick_up"):
		if obj_in_focus != null and obj_in_focus.has_method("pick_up"):
			if weapon_inventory.add_weapon(obj_in_focus.weapon_data):
				obj_in_focus.pick_up()
	
	# Wieldable primary Action Input
	if !get_parent().is_movement_paused:
		if is_wielding and Input.is_action_just_pressed("action_primary"):
			weapon_inventory.action_primary()
		
		if is_wielding and Input.is_action_just_pressed("action_secondary"):
			weapon_inventory.action_secondary(false)
		if is_wielding and Input.is_action_just_released("action_secondary"):
			weapon_inventory.action_secondary(true)
		
		if is_wielding and event.is_action_pressed("reload"):
			if interaction_raycast.is_colliding() and interaction_raycast.get_collider().has_method("interact"):
				return
			else:
				weapon_inventory.attempt_reload()
	
	# Weapon switching using middle mouse dial
	if event.is_action_pressed("next_weapon"):
		weapon_inventory.switch_weapon("Next")
	
	if event.is_action_pressed("prev_weapon"):
		weapon_inventory.switch_weapon("Prev")
	
	if event.is_action_pressed("holster"):
		weapon_inventory.holster()


## Helper function to always get raycast destination point
func get_interaction_raycast_tip(distance_offset : float) -> Vector3:
	if interaction_raycast.is_colliding():
		return interaction_raycast.get_collision_point()
	else:
		var destination_point = interaction_raycast.global_position + (interaction_raycast.target_position.z - distance_offset) * get_viewport().get_camera_3d().get_global_transform().basis.z
		return destination_point
