extends Control


@onready var disabled_cover = $DisabledCover
var tail_data : TailData = null
var skill_cooldown : int


func _ready():
	$Timer.connect("timeout", Callable(self, "_on_cooldown_finished"))
	self.clear_skill_card()


func _process(delta):
	if !$Timer.is_stopped():
		$CD.text = str(int($Timer.time_left))


func setup_skill_card(passed_tail_data, on_cooldown = false, remaining_cooldown = 0):
	self.tail_data = passed_tail_data
	$Label.text = self.tail_data.tail_name
	self.skill_cooldown = owner.tail_manager.get_skill_CD(self.tail_data.skill_name)
	disabled_cover.hide()
	
	if on_cooldown:
		self.start_cooldown(remaining_cooldown)


func clear_skill_card():
	disabled_cover.show()
	self.tail_data = null
	$Label.text = "Empty"
	$Timer.stop()
	$CD.text = "" 


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
	
	disabled_cover.show()


func _on_cooldown_finished():
	$CD.text = ""
	disabled_cover.hide()
