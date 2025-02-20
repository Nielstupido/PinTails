extends Node3D


@onready var skill_animation_player : AnimationPlayer = $"../SkillAnimationsPlayer"
@onready var damage_area_node : Area3D = $"../../Neck/Head/SkillComponentNodes/PunchDamageArea"
var punch_damage : int
var is_skill_enabled = false


func _ready() -> void:
	damage_area_node.connect("body_entered", Callable(self, "_on_enemy_hit"))


func _on_enemy_hit(body) -> void:
	if body.is_in_group("Player") and body != owner:
		#body.take_damage(punch_damage)
		print(" HIT!! --> " + str(body))


func _input(event) -> void:
	if event.is_action_pressed("action_primary") and is_multiplayer_authority() and is_skill_enabled:
		if skill_animation_player.is_playing():
			return
		
		skill_animation_player.play("punch")
		await skill_animation_player.animation_finished
		skill_animation_player.stop()


func execute_skill(damage : int) -> void:
	punch_damage = damage
	is_skill_enabled = true


func skill_timeout() -> void:
	is_skill_enabled = false
