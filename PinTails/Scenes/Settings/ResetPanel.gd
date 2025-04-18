extends PanelContainer


func toggle_panel():
	if self.visible:
		self.hide()
	else:
		self.show()


func _on_yes_pressed():
	Settings.set_setting(InputKeySettings.actions[0], "all")
	toggle_panel() 


func _on_no_pressed():
	toggle_panel()
