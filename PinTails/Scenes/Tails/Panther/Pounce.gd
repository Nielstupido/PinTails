extends Node3D

var pounce_damage : int


func _ready() -> void:
	owner.connect("player_just_landed", Callable(self, "do_damage"))


func execute_skill(damage : int) -> void:
	if !owner.is_on_floor():
		return
	
	pounce_damage = damage
	owner.is_jumping = true
	owner.just_jumped = true
  

func do_damage():
	for body in $DamageArea.get_overlapping_bodies():
		if owner != body and body.is_in_group("Player"):
			body.take_damage(pounce_damage)
	
	$DamageArea.show() 
	await get_tree().create_timer(0.3).timeout
	$DamageArea.hide() 
	