extends Node3D


enum Effects {
	IMPACT_DUST,
	SMALL_IMPACT_DUST,
	POUNCE_IMPACT,
	GROUND_SLAM,
	SHIELD,
}

@onready var impact_dust = $DustEffect
@onready var small_impact_dust = $SmallDustEffect
@onready var pounce_impact = $PounceImpactEffect
@onready var ground_slam = $GroundSlamEffect
@onready var shield = $ShieldEffect


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
			impact_dust.restart()
			impact_dust.emitting = true
		Effects.GROUND_SLAM:
			ground_slam.play_effect()
		Effects.SHIELD:
			shield.show()
			shield.restart()
			shield.emitting = true


@rpc("any_peer", "call_local", "reliable")
func stop_effect(selected_effect : Effects, player_id : int):
	if player_id != owner.name.to_int():
		return
	
	match (selected_effect):
		Effects.SMALL_IMPACT_DUST:
			small_impact_dust.emitting = false
		Effects.SHIELD:
			shield.hide()
			shield.emitting = false
