extends Node3D


@onready var skill_animation_player = $"../SkillAnimationsPlayer"
@onready var damage_area_node : Area3D = $"../../Neck/Head/SkillComponentNodes/PoisonStabDamageArea"
var is_skill_triggered = false
var stab_damage : int


func _ready() -> void: 
	damage_area_node.connect("body_entered", Callable(self, "_on_enemy_hit"))


func _input(event) -> void:
	if event.is_action_pressed("action_primary") and is_skill_triggered:
		skill_animation_player.play("poison_stab")


func _on_enemy_hit(body) -> void:
	if body.is_in_group("Player") and body != owner:
		#body.take_damage(stab_damage)
		print("ENEMY HIT!! ----> " + str(body))
 

func execute_skill(damage : int) -> void:
	stab_damage = damage
	is_skill_triggered = true


func skill_timeout() -> void:
	is_skill_triggered = false
