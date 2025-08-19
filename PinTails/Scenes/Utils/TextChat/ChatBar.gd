extends Control


@onready var chat_entry_scene = preload("res://Scenes/Utils/TextChat/ChatEntry.tscn")
@onready var chatbox = $ChatBox
@onready var convo_container = $ChatBox/ChatViewBox/ScrollContainer/Control/ConvoContainer
@onready var chat_entry_text = $ChatBox/ChatEntryBox/LineEdit
@onready var chat_entry_box = $ChatBox/ChatEntryBox
@onready var chat_quick_view = $ChatQuickView
@onready var chat_quick_view_text = $ChatQuickView/Label


func _ready():
	chatbox.custom_minimum_size = Vector2.ZERO
	chatbox.size = Vector2((get_viewport_rect().size.x / 3), (get_viewport_rect().size.y / 3.5))
	chatbox.anchors_preset = PRESET_BOTTOM_LEFT
	chatbox.position = Vector2(15.0, (get_viewport_rect().size.y - (chatbox.size.y + 15.0)))
	chatbox.hide()
	chat_quick_view.size = Vector2(chatbox.size.x, chat_entry_box.size.y)
	chat_quick_view.anchors_preset = PRESET_BOTTOM_LEFT
	chat_quick_view.position = Vector2(
									15.0, 
									(get_viewport_rect().size.y - (chat_quick_view.size.y + 15.0))
									)
	chat_quick_view.hide()


func _input(event):
	if is_multiplayer_authority() and Input.is_key_pressed(KEY_ENTER):
		if chat_entry_text.has_focus():
			chat_entry_text.release_focus()
			chatbox.hide()
			if chat_entry_text.text != "":
				_add_msg(chat_entry_text.text)
				_show_msg(chat_entry_text.text)
			owner.is_game_paused = false
		else:
			owner.is_game_paused = true
			chat_entry_text.grab_focus()
			chatbox.show()
		
		chat_entry_text.clear()


func _add_msg(chat_text : String):
	var chat_obj = chat_entry_scene.instantiate()
	chat_obj.text = chat_text
	convo_container.add_child(chat_obj)
	ChatSystem.rpc("send_chat", PlayerAccount.username, chat_text)


func _show_msg(chat_text : String):
	if chat_entry_text.has_focus():
		return
	
	chat_quick_view_text.text = chat_text
	chat_quick_view.show()
	await get_tree().create_timer(1.0).timeout
	chat_quick_view.hide()
