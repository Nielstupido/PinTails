extends Node


@rpc("any_peer", "call_local", "reliable")
func player_took_damage(player_id : String):
	if $"../PlayerNodes".has_node(player_id as NodePath):
		$"../PlayerNodes".get_node(player_id as NodePath).take_damage(20)
