extends Control


@onready var player_skills_container = $"../UI/PlayerTails/PlayerSkills/HBoxContainer"
@onready var skill_card1 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard"
@onready var skill_card2 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard2"
@onready var skill_card3 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard3"

var skill_hotkey1
var skill_hotkey2
var skill_hotkey3

var _acqrd_skills : int = 0
var is_waiting_shot_trigger = false
var is_skill_toggle = false
var is_toggle_enabled = false
var is_waiting_double_trigger = false
var is_timed_trigger_enabled = false
var is_multiple_trigger_enabled = false
var trigger_remaining = 0
var active_skill_card = null


func _ready():
	owner.player_dash_stopped.connect(on_skill_duration_finished)
	owner.on_skill_cd.connect(on_skill_duration_finished)
	GameplayManager.tail_picked_up.connect(add_skill)
	GameplayManager.tail_picked_up.connect(reset_skill_dup)
	GameplayManager.tail_removed.connect(remove_skill)
	GameplayManager.tail_removed.connect(reset_skill)
	call_deferred("_setup_hotkeys")


func _setup_hotkeys():
	skill_hotkey1 = skill_card1.hotkey
	skill_hotkey2 = skill_card2.hotkey
	skill_hotkey3 = skill_card3.hotkey
	skill_hotkey1.text = str(OS.get_keycode_string((InputMap.action_get_events("ablty|first_skill"))[0].keycode))
	skill_hotkey2.text = str(OS.get_keycode_string((InputMap.action_get_events("ablty|second_skill"))[0].keycode))
	skill_hotkey3.text = str(OS.get_keycode_string((InputMap.action_get_events("ablty|third_skill"))[0].keycode))


func _input(event):
	if is_multiplayer_authority():
		if event.is_action_pressed("ablty|first_skill"):
			if skill_card1.can_use_skill():
				use_skill(skill_card1)
		
		if event.is_action_pressed("ablty|second_skill"):
			if skill_card2.can_use_skill():
				use_skill(skill_card2)
		
		if event.is_action_pressed("ablty|third_skill"):
			if skill_card3.can_use_skill():
				use_skill(skill_card3)
		
		if Input.is_action_just_pressed("playerhand|action_primary"):
			if is_waiting_shot_trigger || is_waiting_double_trigger:
				is_waiting_shot_trigger = false
				execute_skill()


func remove_skill(tail_data, skill_index) -> void:
	var skill_status
	_acqrd_skills -= 1
	
	if _acqrd_skills == 0: 
		skill_card1.clear_skill_card()
		return
	
	if skill_index == 0:
		skill_card1.clear_skill_card()
		skill_status = skill_card2.on_cooldown() 
		skill_card1.setup_skill_card(skill_card2.tail_data, skill_status[0], skill_status[1])
		skill_card2.clear_skill_card()
	
	if skill_index == 0 or skill_index == 1:
		if skill_card3.tail_data:
			skill_status = []
			skill_status = skill_card3.on_cooldown()
			skill_card2.setup_skill_card(skill_card3.tail_data, skill_status[0], skill_status[1])
		else:
			skill_card2.clear_skill_card()
	
	skill_card3.clear_skill_card()

 
func add_skill(passed_tail_data) -> void:
	player_skills_container.get_child(_acqrd_skills).setup_skill_card(passed_tail_data)
	_acqrd_skills += 1


func use_skill(skill_card : Node) -> void:
	if is_multiple_trigger_enabled and trigger_remaining != 0:
		trigger_remaining -= 1
		execute_skill()
		return
	
	if is_timed_trigger_enabled:
		return
	
	if is_waiting_double_trigger and active_skill_card != null:
		execute_skill()
		return
	
	if is_skill_toggle:
		is_skill_toggle = false
		execute_skill()
		return
	 
	active_skill_card = skill_card
	
	match(active_skill_card.tail_data.skill_type):
		Skills.Skill_Types.SINGLE_TRIGGER:
			execute_skill()
		Skills.Skill_Types.MULTIPLE_TRIGGER:
			is_multiple_trigger_enabled = true
			trigger_remaining = active_skill_card.tail_data.skill_value - 1
			execute_skill()
		Skills.Skill_Types.SHOT_TRIGGER:
			is_waiting_shot_trigger = true
		Skills.Skill_Types.TIMED_SHOT_TRIGGER:
			is_timed_trigger_enabled = true
			execute_skill()
		Skills.Skill_Types.TOGGLE_TRIGGER:
			is_skill_toggle = true
			is_toggle_enabled = true
			execute_skill()
		Skills.Skill_Types.DOUBLE_TRIGGER: 
			execute_skill()
			is_waiting_double_trigger = true
		Skills.Skill_Types.WAIT_SHOT_TRIGGER:
			is_waiting_shot_trigger = true
			execute_skill()


func reset_skill(tail_data, skill_index) -> void:
	trigger_remaining = 0
	is_waiting_shot_trigger = false
	is_timed_trigger_enabled = false
	is_skill_toggle = false
	is_toggle_enabled = false
	is_multiple_trigger_enabled = false
	active_skill_card = null


func reset_skill_dup(tail_data) -> void:
	reset_skill(tail_data, null)


##Filler - might be needed later on
#func prepare_skill():
	#match(owner.tail_manager.get_skill_effect(active_skill_card.tail_data.skill_name)):
		#Skills.Skill_Effects.DAMAGE:
			#execute_skill()
			#print("damage skill")
		#Skills.Skill_Effects.ARMOR:
			#execute_skill()
			#print("armor skil")s
		#Skills.Skill_Effects.DASH:
			#execute_skill() 
			#print("dash skill")
		#Skills.Skill_Effects.STICK: 
			#execute_skill()
			#print("stick skill")


func execute_skill():
	if is_multiplayer_authority():
		var node_str = StringHelper.filter_string(active_skill_card.tail_data.skill_name)
		await owner.skill_nodes.get_node(node_str).execute_skill(
				active_skill_card.tail_data.skill_value,
				self,
				active_skill_card,
				)
		
		if is_timed_trigger_enabled:
			await get_tree().create_timer(active_skill_card.tail_data.skill_duration).timeout
			if active_skill_card:
				owner.skill_nodes.get_node(StringHelper.filter_string(active_skill_card.tail_data.skill_name)).skill_timeout()
			else:
				on_skill_duration_finished()
		elif !is_waiting_shot_trigger and trigger_remaining == 0 and !is_skill_toggle:
			on_skill_duration_finished()


func on_skill_duration_finished(_force_reset : bool = false):
	print("skill finished")
	
	if not _force_reset:
		if active_skill_card == null or (trigger_remaining != 0 and is_multiple_trigger_enabled) or is_toggle_enabled:
			is_toggle_enabled = false
			return
	
	active_skill_card.start_cooldown()
	reset_skill(null, null)
