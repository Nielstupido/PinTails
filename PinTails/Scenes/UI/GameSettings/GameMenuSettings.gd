extends CanvasLayer


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		self.visible = not self.visible
		
		if self.visible:
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			get_tree().paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_Button_pressed():
	get_tree().quit()
