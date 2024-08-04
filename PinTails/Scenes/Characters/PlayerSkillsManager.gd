extends Control


onready var skill_hotkey1 = $HBoxContainer/SkillCard/SkillHotkey
onready var skill_hotkey2 = $HBoxContainer/SkillCard2/SkillHotkey
onready var skill_hotkey3 = $HBoxContainer/SkillCard3/SkillHotkey
onready var skill_card1 = $HBoxContainer/SkillCard
onready var skill_card2 = $HBoxContainer/SkillCard2
onready var skill_card3 = $HBoxContainer/SkillCard3
var _acqrd_skills : int = 0


func _ready():
	GAMEMANAGER.connect("tail_picked_up", self, "add_skill")
	skill_hotkey1.text = str(OS.get_scancode_string((InputMap.get_action_list("first_skill"))[0].scancode))
	skill_hotkey2.text = str(OS.get_scancode_string((InputMap.get_action_list("second_skill"))[0].scancode))
	skill_hotkey3.text = str(OS.get_scancode_string((InputMap.get_action_list("third_skill"))[0].scancode))


func _input(event):
	if event.is_action_pressed("first_skill"):
		if skill_card1.can_use_skill():
			skill_card1.use_skill()
			print("First Skill")
	
	if event.is_action_pressed("second_skill"):
		if skill_card2.can_use_skill():
			skill_card2.use_skill()
			print("Second Skill")
	
	if event.is_action_pressed("third_skill"):
		if skill_card3.can_use_skill():
			skill_card3.use_skill()
			print("Third Skill")


func remove_skill(skill_index):
	var skill_status
	_acqrd_skills -= 1
	
	if _acqrd_skills == 0:
		skill_card1.clear_skill_card()
		return
	
	if skill_index == 0:
		skill_card1.clear_skill_card()
		skill_status = skill_card2.on_cooldown() 
		skill_card1.setup_skill_card(skill_card2.skill_data, skill_status[0], skill_status[1])
		skill_card2.clear_skill_card()
	
	if skill_index == 0 or skill_index == 1:
		if skill_card3.skill_data:
			skill_status = []
			skill_status = skill_card3.on_cooldown()
			skill_card2.setup_skill_card(skill_card3.skill_data, skill_status[0], skill_status[1])
		else:
			skill_card2.clear_skill_card()
	
	skill_card3.clear_skill_card()


func add_skill(passed_tail_data):
	$HBoxContainer.get_child(_acqrd_skills).setup_skill_card(passed_tail_data)
	_acqrd_skills += 1
	print("picked up data == " + str(passed_tail_data.id))
