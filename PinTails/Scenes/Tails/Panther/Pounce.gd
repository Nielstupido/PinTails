extends Node3D

var pounce_damage : int


func _ready() -> void:
	owner.connect("player_just_landed", Callable(self, "do_damage"))


func execute_skill(damage : int) -> void:
	if !owner.is_on_floor():
		return
	
	pounce_damage = damage
	owner.is_jumping = true
	owner.is_pouncing = true
  

func do_damage():
	rpc("pounce_impact_effect", owner.name.to_int())
	
	for body in $DamageArea.get_overlapping_bodies():
		if owner != body and body.is_in_group("Player"):
			body.take_damage(pounce_damage)
	
	$DamageArea.show() 
	await get_tree().create_timer(0.3).timeout
	$DamageArea.hide()


@rpc("any_peer", "call_local", "reliable")
func pounce_impact_effect(player_id : int):
	if player_id == owner.name.to_int():
		$ImpactEffect.emitting = true
