extends CanvasLayer


func _ready():
	$SettingsUI/MainPanel/CloseSettingsBtn.pressed.connect(_close_settings)


func _input(event):
	if event.is_action_pressed("menu") and !owner.is_dead:
		if self.visible:
			owner.on_resume_movement()
			self.hide()
		else:
			owner.on_pause_movement()
			self.show()

 
func _on_Button_pressed():
	get_tree().quit()


func _close_settings():
	self.hide()
