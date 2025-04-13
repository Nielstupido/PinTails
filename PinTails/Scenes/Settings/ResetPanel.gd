extends PanelContainer


func toggle_panel():
	if self.visible:
		self.hide()
	else:
		self.show()


func _on_yes_pressed():
	Settings.set_setting(KeybindingManager.keys_default.keys()[3], "all")
	toggle_panel() 


func _on_no_pressed():
	toggle_panel()
