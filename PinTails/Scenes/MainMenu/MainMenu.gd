extends Node


func _on_PlayBtn_pressed():
	MATCHMANAGER.start_matchmaking("orya")


func _on_SettingsBtn_pressed():
	pass


func _on_ExitBtn_pressed():
	get_tree().quit()
