extends TailSkill


var _tween : Tween
var _is_activated = false

#Override this function
func _execute_skill(concealment_length : int) -> void:
	if _is_activated:
		_is_activated = false
		_stop_skill()
		return
	
	_is_activated = true
	owner.invi_screen_effect.toggle_invi_effect(true)
	_skill_card_node.toggle_hotkey_cover(true)
	_tween = get_tree().create_tween()
	await _tween.tween_property(owner.body, "transparency", 1.0, 0.5).finished
	await get_tree().create_timer(concealment_length).timeout
	
	if _is_activated:
		_stop_skill()


func _stop_skill() -> void:
	if _tween:
		_tween.stop()
	
	_tween = get_tree().create_tween()
	_is_activated = false
	_skill_card_node.start_cooldown()
	owner.invi_screen_effect.toggle_invi_effect(false)
	await _tween.tween_property(owner.body, "transparency", 0.0, 0.7).finished
