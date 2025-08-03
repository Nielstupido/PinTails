extends TailSkill


@onready var player_effects_manager = $"../../PlayerEffectsManager"


#Override this function
func _execute_skill(duration : int) -> void:
	if _is_activated:
		return
	
	_is_activated = true
	_skill_card_node.activate_skill(self, true, false, true, duration)
	owner.is_dmg_immuned = true
	owner.is_slowed = true
	
	player_effects_manager.rpc("play_effect", 
		player_effects_manager.Effects.SHIELD, 
		owner.name.to_int())


func stop_skill() -> void:
	_is_activated = false
	_skill_card_node.start_cooldown()
	player_effects_manager.rpc("stop_effect", 
		player_effects_manager.Effects.SHIELD, 
		owner.name.to_int())
	owner.is_dmg_immuned = false
	owner.is_slowed = false
