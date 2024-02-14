extends Node


func _ready():
	pass 


func _on_PlayBtn_pressed():
	var _error = get_tree().change_scene("res://Scenes/Game/Game.tscn")


func _on_SettingsBtn_pressed():
	pass


func _on_ExitBtn_pressed():
	get_tree().quit()

