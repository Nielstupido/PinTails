extends Node


func open_node(target_node : Node, target_node_bg : Node = null) -> void:
	target_node.scale = Vector2.ZERO
	target_node.pivot_offset = Vector2(target_node.size.x/2, target_node.size.y/2)
	target_node.modulate.a = 0.0
	
	if target_node_bg:
		target_node_bg.show()
	else:
		target_node.show()
	
	get_tree().create_tween().tween_property(target_node, 
		"modulate:a", 1.0, 0.2).set_delay(0.1)
	get_tree().create_tween().tween_property(target_node,
		"scale", Vector2.ONE, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)


func close_node(target_node : Node, on_transition : bool, target_node_bg : Node = null) -> void:
	target_node.pivot_offset = Vector2(target_node.size.x/2, target_node.size.y/2)
	
	if !on_transition:
		get_tree().create_tween().tween_property(target_node, 
			"modulate:a", 0.0, 0.12).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		
		if target_node_bg:
			get_tree().create_tween().tween_property(target_node_bg, 
				"self_modulate:a", 0.0, 0.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		
		await get_tree().create_tween().tween_property(target_node, 
			"scale", Vector2.ZERO, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).finished
	
	if target_node_bg:
		target_node_bg.hide()
		target_node_bg.self_modulate.a = 1.0
	else:
		target_node.hide()
	
	target_node.modulate.a = 1.0
