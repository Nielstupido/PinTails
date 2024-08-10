extends Control


var skill_data : TailData = null
var skill_CD : int


func _ready():
	$Timer.connect("timeout", Callable(self, "_on_CD_finished"))
	self.clear_skill_card()


func _process(delta):
	if !$Timer.is_stopped():
		$CD.text = str(int($Timer.time_left))


func setup_skill_card(passed_tail_data, on_CD = false, remaining_CD = 0):
	self.skill_data = passed_tail_data
	$Label.text = self.skill_data.tail_name
	self.skill_CD = owner.tail_manager.get_skill_CD(self.skill_data.tail_active_attrb)
	
	if on_CD:
		self.use_skill(remaining_CD)


func clear_skill_card():
	self.skill_data = null
	$Label.text = "Empty"
	$Timer.stop()
	$CD.text = ""


func can_use_skill() -> bool:
	if !on_cooldown()[0] and skill_data:
		return true
	
	return false


func on_cooldown() -> Array:
	if $Timer.is_stopped():
		return [false, 0]
	
	return [true, $Timer.time_left]


func use_skill(remaining_CD = 0):
	if remaining_CD == 0:
		$Timer.start(self.skill_CD)
	else:
		$Timer.start(remaining_CD)


func _on_CD_finished():
	$CD.text = ""
