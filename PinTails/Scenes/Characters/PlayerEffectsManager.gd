extends Node3D


enum Effects {
	IMPACT_DUST
}

@onready var dust_effect = $DustEffect


@rpc("any_peer", "call_local", "reliable")
func play_effect(selected_effect : Effects, player_id : int):
	if player_id != owner.name.to_int():
		return
	
	match (selected_effect):
		Effects.IMPACT_DUST:
			dust_effect.emitting = false
			dust_effect.emitting = true
