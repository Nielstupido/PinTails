extends TailSkill


@onready var player_effects_manager = $"../../PlayerEffectsManager"


func _ready() -> void:
	owner.connect("player_dash_stopped", func(): _is_activated = false)


#Override this function
func _execute_skill(dash_rate : int) -> void:
	if _is_activated:
		do_ground_slam()
	else:
		_is_activated = true
		owner.dash_rate = Vector3(dash_rate, 1.0, dash_rate)
		owner.dash_length = 200
		owner.dash_lerp_speed = 0.1
		owner.is_dashing = true


func do_ground_slam() -> void:
	_is_activated = false
	owner.is_dashing = false
	owner.player_dash_stopped.emit()
	
	player_effects_manager.rpc("play_effect", 
			player_effects_manager.Effects.GROUND_SLAM, 
			owner.name.to_int())
