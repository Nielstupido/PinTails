extends Control


@onready var hotkey = $VBox/VBox/SkillHotkey
@onready var _hotkey_additional = $VBox/SkillHotkey
@onready var _disabled_cover = $VBox/VBox/Panel/DisabledCover
@onready var _activated_skill_cover = $VBox/VBox/SkillHotkey/ActivatedSkillCover
@onready var _cd_text = $VBox/VBox/Panel/CD
@onready var _skill_label_text = $VBox/VBox/Panel/Label
@onready var _trigger_count_nodes = $VBox/SkillDuration/HBox
@onready var _skill_limit_bar = $VBox/SkillDuration
var _skill_node : Object
var _trigger_count_left : int = 0
var tail_data : TailData = null
var skill_cooldown : int
var cooled_down : bool = false
var skill_time_left : float = 0.0
var skill_limit_time : float = 15.0
var is_skill_limit_running : bool = false


func _ready():
	$CooldownTimer.timeout.connect(_on_cooldown_finished)
	_hotkey_additional.hide()
	self.clear_skill_card()
	toggle_skill_cover(true)
	toggle_hotkey_cover(false)
	_prepare_trigger_counter(false)


func _process(delta):
	if !$CooldownTimer.is_stopped(): 
		_cd_text.text = str(int($CooldownTimer.time_left))
	
	if is_skill_limit_running:
		skill_time_left -= delta
		
		if skill_time_left <= 0:
			skill_time_left = 0
			is_skill_limit_running = false
			start_cooldown()
			_prepare_trigger_counter(false)
			_skill_node.is_activated = false
		
		_skill_limit_bar.value = skill_time_left


func _on_cooldown_finished():
	cooled_down = false
	_cd_text.text = ""
	_disabled_cover.hide()


func _prepare_trigger_counter(show : bool):
	_skill_limit_bar.modulate.a = 1.0 if show else 0.0 
	
	if show:
		_trigger_count_left = tail_data.skill_value - 1
		_skill_limit_bar.max_value = skill_limit_time
		_skill_limit_bar.value = skill_limit_time
		skill_time_left = skill_limit_time
		_hotkey_additional.show()
		toggle_hotkey_cover(true)
	else: 
		toggle_hotkey_cover(false)
		_hotkey_additional.hide()
	
	for counter in _trigger_count_nodes.get_children():
		if show:
			counter.show()
		else: 
			counter.hide()


func setup_skill_card(passed_tail_data, on_cooldown = false, remaining_cooldown = 0):
	if passed_tail_data.skill_type == Skills.Skill_Types.MULTIPLE_TRIGGER:
		_prepare_trigger_counter(false)
	
	cooled_down = false
	self.tail_data = passed_tail_data
	_skill_label_text.text = StringHelper.filter_string(Tail.Classes.find_key(self.tail_data.tail_class))
	self.skill_cooldown = self.tail_data.skill_cd
	toggle_skill_cover(false)
	
	if on_cooldown:
		start_cooldown(remaining_cooldown)


func clear_skill_card():
	_prepare_trigger_counter(false)
	toggle_skill_cover(true)
	self.tail_data = null
	_skill_label_text.text = "Empty"
	$CooldownTimer.stop()
	_cd_text.text = "" 
	cooled_down = false 


func can_use_skill() -> bool:
	if !on_cooldown()[0] and tail_data:
		return true
	
	return false


func add_trigger_count() -> bool:
	_trigger_count_left -= 1
	
	if _trigger_count_left == 0:
		start_cooldown()
		_prepare_trigger_counter(false)
		return false
	else:
		_trigger_count_nodes.get_child(_trigger_count_left - 1).hide()
		return true


func activate_skill(node_obj : Object = null) -> void:
	_skill_node = node_obj
	_hotkey_additional.text = hotkey.text
	
	if tail_data.skill_type == Skills.Skill_Types.MULTIPLE_TRIGGER:
		_prepare_trigger_counter(true)
		is_skill_limit_running = true


func on_cooldown() -> Array: 
	if $CooldownTimer.is_stopped():
		return [false, 0]
	
	return [true, $CooldownTimer.time_left]


func start_cooldown(remaining_cooldown = 0): 
	if cooled_down:
		return
	
	cooled_down = true
	
	if remaining_cooldown == 0:
		owner.emit_signal("on_skill_cd", true)
		$CooldownTimer.start(self.skill_cooldown)
	else:
		$CooldownTimer.start(remaining_cooldown)
	
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
