extends TailSkill


@onready var player_effects_manager = $"../../PlayerEffectsManager"
var pounce_damage : int


func _ready() -> void:
	owner.player_just_landed.connect(do_damage)


#Override this function
func _execute_skill(damage : int) -> void:
	if _is_activated or !owner.is_on_floor():
		return
	
	_is_activated = true
	pounce_damage = damage
	owner.is_jumping = true
	owner.is_pouncing = true
  

func do_damage():
	print("play pounce impact")
	player_effects_manager.rpc("play_effect", 
			player_effects_manager.Effects.POUNCE_IMPACT, 
			owner.name.to_int())
	
	for body in $DamageArea.get_overlapping_bodies():
		if owner != body and body.is_in_group("Player"):
			body.take_damage(pounce_damage)
	
	$DamageArea.show() 
	await get_tree().create_timer(0.3).timeout
	$DamageArea.hide()
	_skill_card_node.start_cooldown()
	await get_tree().create_timer(_skill_card_node.tail_data.skill_cd).timeout
	_is_activated = false
