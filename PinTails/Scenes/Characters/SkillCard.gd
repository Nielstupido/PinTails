extends Control


@onready var _disabled_cover = $VBox/Panel/DisabledCover
@onready var _activated_skill_cover = $VBox/SkillHotkey/ActivatedSkillCover
@onready var cd_text = $VBox/Panel/CD
@onready var skill_label_text = $VBox/Panel/Label
@onready var hotkey = $VBox/SkillHotkey
var tail_data : TailData = null
var skill_cooldown : int


func _ready():
	$Timer.timeout.connect(_on_cooldown_finished)
	self.clear_skill_card()
	toggle_skill_cover(true)
	toggle_hotkey_cover(false)


func _process(delta):
	if !$Timer.is_stopped(): 
		cd_text.text = str(int($Timer.time_left))


func setup_skill_card(passed_tail_data, on_cooldown = false, remaining_cooldown = 0):
	self.tail_data = passed_tail_data          
	skill_label_text.text = StringHelper.filter_string(Tail.Classes.find_key(self.tail_data.tail_class))
	self.skill_cooldown = self.tail_data.skill_cd
	toggle_skill_cover(false)
	
	if on_cooldown:
		self.start_cooldown(remaining_cooldown)


func clear_skill_card():
	toggle_skill_cover(true)
	self.tail_data = null
	skill_label_text.text = "Empty"
	$Timer.stop()
	cd_text.text = "" 


func can_use_skill() -> bool:
	if !on_cooldown()[0] and tail_data:
		return true
	
	return false


func on_cooldown() -> Array: 
	if $Timer.is_stopped():
		return [false, 0]
	
	return [true, $Timer.time_left]


func start_cooldown(remaining_cooldown = 0):
	if remaining_cooldown == 0:
		$Timer.start(self.skill_cooldown)
	else:
		$Timer.start(remaining_cooldown)
	
	toggle_hotkey_cover(false)     
	toggle_skill_cover(true)


func toggle_skill_cover(is_activate_cover : bool):
	if is_activate_cover:
		_disabled_cover.show()
	else:
		_disabled_cover.hide()


func toggle_hotkey_cover(is_activate_cover : bool):
	if is_activate_cover:
		_activated_skill_cover.show()
	else:
		_activated_skill_cover.hide()


func _on_cooldown_finished():
	cd_text.text = ""
	_disabled_cover.hide()
