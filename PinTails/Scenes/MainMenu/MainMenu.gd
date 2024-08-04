extends Node


onready var lobby_scene = load("res://Scenes/Lobby/Lobby.tscn")


func _on_PlayBtn_pressed():
	get_tree().change_scene_to(lobby_scene)


func _on_SettingsBtn_pressed():
	pass


func _on_ExitBtn_pressed():
	get_tree().quit()
