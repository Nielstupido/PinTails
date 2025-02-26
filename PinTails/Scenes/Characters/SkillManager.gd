extends Control

@onready var player_skills_container = $"../UI/PlayerTails/PlayerSkills/HBoxContainer"
@onready var skill_hotkey1 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard/SkillHotkey"
@onready var skill_hotkey2 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard2/SkillHotkey"
@onready var skill_hotkey3 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard3/SkillHotkey"
@onready var skill_card1 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard"
@onready var skill_card2 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard2"
@onready var skill_card3 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard3"

var _acqrd_skills : int = 0
var is_waiting_shot_trigger = false
var is_waiting_double_trigger = false
var is_timed_trigger_enabled = false
var active_skill_card = null


func _ready():
	owner.connect("player_dash_stopped", Callable(self, "on_skill_duration_finished"))
	GAMEPLAYMANAGER.connect("tail_picked_up", Callable(self, "add_skill"))
	GAMEPLAYMANAGER.connect("tail_picked_up", Callable(self, "reset_skill_dup"))
	GAMEPLAYMANAGER.connect("tail_removed", Callable(self, "remove_skill"))
	GAMEPLAYMANAGER.connect("tail_removed", Callable(self, "reset_skill"))
	skill_hotkey1.text = str(OS.get_keycode_string((InputMap.action_get_events("first_skill"))[0].keycode))
	skill_hotkey2.text = str(OS.get_keycode_string((InputMap.action_get_events("second_skill"))[0].keycode))
	skill_hotkey3.text = str(OS.get_keycode_string((InputMap.action_get_events("third_skill"))[0].keycode))


func _input(event):
	if is_multiplayer_authority():
		if event.is_action_pressed("first_skill"):
			if skill_card1.can_use_skill():
				use_skill(skill_card1)
		
		if event.is_action_pressed("second_skill"):
			if skill_card2.can_use_skill():
				use_skill(skill_card2)
		
		if event.is_action_pressed("third_skill"):
			if skill_card3.can_use_skill():
				use_skill(skill_card3)
		
		if Input.is_action_just_pressed("action_primary"):
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
	if is_timed_trigger_enabled:
		return
	
	if is_waiting_double_trigger and active_skill_card != null:
		execute_skill()
	 
	active_skill_card = skill_card
	
	match(active_skill_card.tail_data.skill_type):
		SKILLS.Skill_Types.SINGLE_TRIGGER:
			execute_skill()
		SKILLS.Skill_Types.SHOT_TRIGGER:
			is_waiting_shot_trigger = true
		SKILLS.Skill_Types.TIMED_SHOT_TRIGGER:
			is_timed_trigger_enabled = true
			execute_skill()
		SKILLS.Skill_Types.TOGGLE_TRIGGER:
			execute_skill()
		SKILLS.Skill_Types.DOUBLE_TRIGGER: 
			execute_skill()
			is_waiting_double_trigger = true
		SKILLS.Skill_Types.WAIT_SHOT_TRIGGER:
			is_waiting_shot_trigger = true
			execute_skill()


func reset_skill(tail_data, skill_index) -> void:
	is_waiting_shot_trigger = false
	is_timed_trigger_enabled = false
	active_skill_card = null


func reset_skill_dup(tail_data) -> void:
	reset_skill(tail_data, null)


##Filler - might needed later on
#func prepare_skill():
	#match(owner.tail_manager.get_skill_effect(active_skill_card.tail_data.skill_name)):
		#SKILLS.Skill_Effects.DAMAGE:
			#execute_skill()
			#print("damage skill")
		#SKILLS.Skill_Effects.ARMOR:
			#execute_skill()
			#print("armor skil")s
		#SKILLS.Skill_Effects.DASH:
			#execute_skill() 
			#print("dash skill")
		#SKILLS.Skill_Effects.STICK: 
			#execute_skill()
			#print("stick skill")


func execute_skill():
	owner.skill_nodes.get_node(STRINGHELPER.filter_string(active_skill_card.tail_data.skill_name)).execute_skill(active_skill_card.tail_data.skill_value)
	
	if is_timed_trigger_enabled:
		await get_tree().create_timer(active_skill_card.tail_data.skill_duration).timeout
		owner.skill_nodes.get_node(STRINGHELPER.filter_string(active_skill_card.tail_data.skill_name)).skill_timeout()
		on_skill_duration_finished()
	elif !is_waiting_shot_trigger:
		on_skill_duration_finished()


func on_skill_duration_finished():
	if active_skill_card == null:
		return
	
	active_skill_card.start_cooldown()
	reset_skill(null, null)
