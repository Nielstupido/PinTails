extends Node3D


@onready var skill_animation_player : AnimationPlayer = $"../SkillAnimationsPlayer"
@onready var damage_area_node : Area3D = $"../../Neck/Head/SkillComponentNodes/PunchDamageArea"
var punch_damage : int


func _ready() -> void:
	damage_area_node.connect("body_entered", Callable(self, "_on_enemy_hit"))


func execute_skill(damage : int) -> void:
	punch_damage = damage
	skill_animation_player.play("punch")
	await skill_animation_player.animation_finished
	skill_animation_player.stop()


func _on_enemy_hit(body):
	if body.is_in_group("Player") and body != owner:
		#body.take_damage(punch_damage)
		print(" HIT!! --> " + str(body))
