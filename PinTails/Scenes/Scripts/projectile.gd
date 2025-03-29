extends RigidBody3D


# Lifespan is being set by the Lifespan timer.
#@onready var lifespan = $Lifespan
# Damage is being set by the wieldable.
var damage_amount : int = 0
## Determine what happens if the projectile hits something. Keep this false for stuff like Arrows. True for stuff like bullets or rockets.
@export var destroy_on_impact : bool = true
## Determine if the player can pick this projectile up again.
@export var is_pickup : bool = false
#@export var slot_data : InventorySlotPD
@export var interaction_text : String = "Pick up"

var projectile_velocity = 50
var camera_collision : Vector3 :
	set(value):
		if value == Vector3.ZERO:
			return
		
		var direction = (value - get_parent().get_global_transform().origin).normalized()
		set_linear_velocity(direction * projectile_velocity)


#func _ready():
	#lifespan.timeout.connect(on_timeout)


func on_timeout():
	_destroy()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		print(self, " _on_body_entered: ", body)
		body.take_damage(damage_amount)
		if destroy_on_impact:
			_destroy()
	
	if destroy_on_impact:
		_destroy()


func _destroy():
	if is_multiplayer_authority():
		$MultiplayerSynchronizer.public_visibility = false
	
	$Lifespan.stop()
	
	if multiplayer.is_server():
		queue_free()
	
	#get_tree().root.get_node("Game/Map/MapTest").spawner.rpc("remove_obj",  self.get_path(), is_multiplayer_authority())


#func interact(body):
	#if is_pickup:
		#print("Picking up ", self)
		#if body.get_parent().inventory_data.pick_up_slot_data(slot_data):
			#body.send_hint(slot_data.inventory_item.icon, slot_data.inventory_item.name + " added to inventory.")
			##Audio.play_sound(slot_data.inventory_item.sound_pickup)
			#queue_free()
