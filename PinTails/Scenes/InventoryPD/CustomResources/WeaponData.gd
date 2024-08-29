@tool
extends Resource
class_name WeaponData


## Name of Item as it appears in game.
@export var name : String = ""
## Description of Item as it'll appear in the HUD / Inventory menu
@export_multiline var descpription : String = ""
## Icon of Item for HUD / Inventory
@export var icon : Texture2D
@export_range(1, 200) var power : int
## Path to Scene that will be spawned when item is removed from inventory to be dropped into the world.
@export_file("*.tscn") var drop_scene
## Icon that is displayed with the hint that pops up when used. If left blank, the default hint icon is shown.
@export var hint_icon_on_use : Texture2D

@export_subgroup("Audio")
## Audio that plays when item is used.
@export var sound_use : AudioStream
@export var sound_pickup : AudioStream
@export var sound_drop : AudioStream

@export_group("Weapon settings")
# Signal that gets sent when the weapon ammo changes. Currently used to update Slot UI
signal ammo_changed()
## HUD text for primary use (for example: shoot, switch on/off etc.)
@export var primary_use_prompt : String
## HUD text for secondary use (for example: swing, look down sight, etc.)
@export var secondary_use_prompt : String
## Icon that is displayed on the HUD when item is wielded.
@export var weapon_data_icon : Texture2D
var weapon_data_text : String
## The maximum ammo of the weapon
@export var mag_size : float
@export var starting_total_ammo : float
@export var weapon_range : float
@export var weapon_damage : float
@export_subgroup("Animations")
@export var equip_anim : String
@export var unequip_anim : String
@export var reload_anim : String
@export var use_anim : String

# Variables for Wielded Items
var current_total_ammo : float
var current_mag_ammo : float
var player_interaction_component
var is_current_weapon : bool
var was_picked_up = false


func picked_up():
	if !was_picked_up:
		current_mag_ammo = mag_size
		current_total_ammo = starting_total_ammo
		was_picked_up = true


# Functions for WIELDABLES 
func take_out():
	print("Taking out ", name)
	player_interaction_component.change_wieldable_to(self)
#	var scene_to_wield = load(drop_scene)
#	wielded_item = scene_to_wield.instantiate()
#	wielder.get_parent().add_child(wielded_item)
#	wielded_item.pick_up(wielder)
	is_current_weapon = true


func put_away():
	print("Putting away ", name)
	player_interaction_component.change_wieldable_to(null)
	is_current_weapon = false
#	if wielded_item != null:
#		wielded_item.queue_free()


func update_wieldable_data(_player_interaction_component : PlayerInteractionComponent):
	if _player_interaction_component: #Only update if something get's passed
		player_interaction_component = _player_interaction_component
	weapon_data_text = str(int(current_mag_ammo)) + "|" + str(current_total_ammo)
	player_interaction_component.emit_signal("updated_wieldable_data", weapon_data_icon, weapon_data_text)


func on_shoot(amount = 1):
	current_mag_ammo -= amount
	current_total_ammo -= amount
	
	if is_current_weapon:
		update_wieldable_data(null)
	
	ammo_changed.emit()


func on_reload():
	current_total_ammo -= (current_mag_ammo + mag_size)
	current_mag_ammo = mag_size
	
	if is_current_weapon:
		update_wieldable_data(null)
	ammo_changed.emit()
