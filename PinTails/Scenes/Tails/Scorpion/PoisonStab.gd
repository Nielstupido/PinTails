extends Node3D


@onready var skill_animation_player = $"../SkillAnimationsPlayer"
@onready var damage_area_node : Area3D = $"../../Neck/Head/SkillComponentNodes/PoisonStabDamageArea"
var stab_damage : int


func _ready() -> void:
	damage_area_node.connect("body_entered", Callable(self, "_on_enemy_hit"))


func execute_skill(damage : int):
	stab_damage = damage
	skill_animation_player.play("poison_stab")


func _on_enemy_hit(body):
	if body.is_in_group("Player") and body != owner:
		#body.take_damage(stab_damage)
		print("ENEMY HIT!! ----> " + str(body))
