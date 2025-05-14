extends TailSkill


@onready var player_effects_manager = $"../../PlayerEffectsManager"
var pounce_damage : int


func _ready() -> void:
	owner.player_just_landed.connect(do_damage)


#Override this function
func _execute_skill(damage : int) -> void:
	if !owner.is_on_floor():
		return
	
	pounce_damage = damage
	owner.is_jumping = true
	owner.is_pouncing = true
  

func do_damage():
	player_effects_manager.rpc("stop_effect", 
			player_effects_manager.Effects.POUNCE_IMPACT, 
			owner.name.to_int())
	
	for body in $DamageArea.get_overlapping_bodies():
		if owner != body and body.is_in_group("Player"):
			body.take_damage(pounce_damage)
	
	$DamageArea.show() 
	await get_tree().create_timer(0.3).timeout
	$DamageArea.hide()
