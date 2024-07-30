extends Control


onready var skill_hotkey1 = $HBoxContainer/SkillCard/SkillHotkey
onready var skill_hotkey2 = $HBoxContainer/SkillCard2/SkillHotkey
onready var skill_hotkey3 = $HBoxContainer/SkillCard3/SkillHotkey


func _ready():
	GAMEMANAGER.connect("tail_picked_up", self, "add_skill")
	skill_hotkey1.text = str(OS.get_scancode_string((InputMap.get_action_list("first_skill"))[0].scancode))
	skill_hotkey2.text = str(OS.get_scancode_string((InputMap.get_action_list("second_skill"))[0].scancode))
	skill_hotkey3.text = str(OS.get_scancode_string((InputMap.get_action_list("third_skill"))[0].scancode))


func add_skill(picked_up_data):
	print("picked up data == " + str(picked_up_data.id))
