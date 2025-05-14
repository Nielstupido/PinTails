extends TailSkill


#Override this function
func _execute_skill(concealment_length : int) -> void:
	owner.invi_screen_effect.toggle_invi_effect(true)
	await create_tween().tween_property(owner.body, "transparency", 1.0, 0.5).finished
	_skill_card_node.toggle_hotkey_cover(true)
	await get_tree().create_timer(concealment_length).timeout
	_skill_card_node.toggle_skill_cover(true)
	owner.invi_screen_effect.toggle_invi_effect(false)
	await create_tween().tween_property(owner.body, "transparency", 0.0, 0.7).finished
