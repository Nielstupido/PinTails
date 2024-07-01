extends Node


onready var lobby_node = $Lobby


func _on_PlayBtn_pressed():
	lobby_node.open_lobby()


func _on_SettingsBtn_pressed():
	pass


func _on_ExitBtn_pressed():
	get_tree().quit()
