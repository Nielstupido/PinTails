extends Node3D


enum Effects {
	IMPACT_DUST,
	SMALL_IMPACT_DUST,
	POUNCE_IMPACT,
	GROUND_SLAM
}

@onready var impact_dust = $DustEffect
@onready var small_impact_dust = $SmallDustEffect
@onready var pounce_impact = $SmallDustEffect
@onready var ground_slam = $GroundSlamEffect


@rpc("any_peer", "call_local", "reliable")
func play_effect(selected_effect : Effects, player_id : int):
	if player_id != owner.name.to_int():
		return
	
	match (selected_effect):
		Effects.IMPACT_DUST:
			impact_dust.restart()
			impact_dust.emitting = true
		Effects.SMALL_IMPACT_DUST:
			if !small_impact_dust.emitting:
				small_impact_dust.restart()
				small_impact_dust.emitting = true
		Effects.POUNCE_IMPACT:
			pounce_impact.restart()
			pounce_impact.emitting = true
		Effects.GROUND_SLAM:
			ground_slam.play_effect()


@rpc("any_peer", "call_local", "reliable")
func stop_effect(selected_effect : Effects, player_id : int):
	if player_id != owner.name.to_int():
		return
	
	match (selected_effect):
		Effects.SMALL_IMPACT_DUST:
			small_impact_dust.emitting = false
