extends ColorRect


@onready var player_name_node = $RichTextLabel


func _on_PlayBtn_pressed():
	MATCHMANAGER.start_matchmaking(PLAYERACCOUNT.username)
	#GAMEPLAYMANAGER.server_mode_selected = false
	GAMEPLAYMANAGER.server_mode_selected = true


func _on_SettingsBtn_pressed():
	pass


func _on_ExitBtn_pressed():
	get_tree().quit()


func _on_visibility_changed():
	if self.visible and PLAYERACCOUNT.username:
		player_name_node.text = str(PLAYERACCOUNT.username)


func _on_deathmatch_pressed():
	GAMEPLAYMANAGER.server_mode_selected = true
	GAMEPLAYMANAGER.load_game_play_scene()


func _on_capture_flag_pressed():
	GAMEPLAYMANAGER.server_mode_selected = false
	GAMEPLAYMANAGER.load_game_play_scene()
