extends Control

@onready var player_skills_container = $"../UI/PlayerTails/PlayerSkills/HBoxContainer"
@onready var skill_hotkey1 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard/SkillHotkey"
@onready var skill_hotkey2 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard2/SkillHotkey"
@onready var skill_hotkey3 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard3/SkillHotkey"
@onready var skill_card1 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard"
@onready var skill_card2 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard2"
@onready var skill_card3 = $"../UI/PlayerTails/PlayerSkills/HBoxContainer/SkillCard3"

var _acqrd_skills : int = 0
var is_skill_waiting_shot_trigger = false
var active_skill_card = null


func _ready():
	GAMEMANAGER.connect("tail_picked_up", Callable(self, "add_skill"))
	GAMEMANAGER.connect("tail_picked_up", Callable(self, "reset_skill"))
	GAMEMANAGER.connect("tail_removed", Callable(self, "reset_skill"))
	skill_hotkey1.text = str(OS.get_keycode_string((InputMap.action_get_events("first_skill"))[0].keycode))
	skill_hotkey2.text = str(OS.get_keycode_string((InputMap.action_get_events("second_skill"))[0].keycode))
	skill_hotkey3.text = str(OS.get_keycode_string((InputMap.action_get_events("third_skill"))[0].keycode))


func _input(event):
	if event.is_action_pressed("first_skill"):
		if skill_card1.can_use_skill():
			use_skill(skill_card1)
			print("First Skill")
	
	if event.is_action_pressed("second_skill"):
		if skill_card2.can_use_skill():
			use_skill(skill_card2)
			print("Second Skill")
	
	if event.is_action_pressed("third_skill"):
		if skill_card3.can_use_skill():
			use_skill(skill_card3)
			print("Third Skill")


func remove_skill(skill_index) -> void:
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
	print("picked up data == " + str(passed_tail_data))


func use_skill(skill_card : Node) -> void:
	active_skill_card = skill_card
	
	match(owner.tail_manager.get_skill_type(active_skill_card.tail_data.skill_name)):
		GAMEMANAGER.SkillTypes.SINGLE_TRIGGER:
			active_skill_card.start_cooldown()
			execute_skill()
			print("single trigger")
		GAMEMANAGER.SkillTypes.SHOT_TRIGGER:
			is_skill_waiting_shot_trigger = true
			print("shot trigger")
		GAMEMANAGER.SkillTypes.TOGGLE_TRIGGER:
			print("toggle trigger")
		GAMEMANAGER.SkillTypes.DOUBLE_TRIGGER:
			print("double trigger")


func reset_skill(passed_tail_data) -> void:
	is_skill_waiting_shot_trigger = false
	active_skill_card = null


##Filler - might needed later on
#func prepare_skill():
	#match(owner.tail_manager.get_skill_effect(active_skill_card.tail_data.skill_name)):
		#GAMEMANAGER.SkillEffects.DAMAGE:
			#execute_skill()
			#print("damage skill")
		#GAMEMANAGER.SkillEffects.ARMOR:
			#execute_skill()
			#print("armor skil")
		#GAMEMANAGER.SkillEffects.DASH:
			#execute_skill() 
			#print("dash skill")
		#GAMEMANAGER.SkillEffects.STICK: 
			#execute_skill()
			#print("stick skill")


func execute_skill():
	var skill_name = active_skill_card.tail_data.skill_name
	owner.skill_nodes.get_node(skill_name.replace(" ", "")).execute_skill(owner.tail_manager.get_skill_value(skill_name))
