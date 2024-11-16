extends ColorRect


@onready var player_name_node = $RichTextLabel


func _on_PlayBtn_pressed():
	MATCHMANAGER.start_matchmaking("orya")


func _on_SettingsBtn_pressed():
	pass


func _on_ExitBtn_pressed():
	get_tree().quit()


func _on_visibility_changed():
	if self.visible and owner.network_connection.player_account:
		player_name_node.text = str(owner.network_connection.player_account)
